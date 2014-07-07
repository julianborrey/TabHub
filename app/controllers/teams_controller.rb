class TeamsController < ApplicationController
   include ApplicationHelper
   include TournamentsHelper
   
   before_action :signed_in_user, only: [:show, :new, :authorized_for_make_team]
   #check to see if we can chain these before actions like I have tried here
   #create_by... will call authorized_for... which callse :signed_in_user.

   before_action :edit_before_tournament_starts, only: [:edit, :destroy]
   before_action :authorized_for_make_team, only: [:create_by_tabbie_or_user, 
                                                   :destroy_by_tabbie_or_user]
   #before_action :authorized_for_team, only: [:destroy, :edit, :update]
   
   #only from the user's end
   #one can make a team for them self
   #or the president can make a team for their insitution
   #a tabbie could make a team for their tournament from the ctrl panel side
   def new
      @team = Team.new();
   end
   
   #checklist: name not blank, all users found, (all of same institution,)
   #that all users are not also involved in another team or are adjs,
   #name is not a duplicate --> really can do this with normal rails though
   #we allow members to be the same person ==> iron man
   def create_by_tabbie_or_user
      #we may call this from /control/teams or /registration/individual
      
      @tournament = Tournament.find(safe_params[:id]);
      @emails     = safe_params[:emails]; #need this incase we render
      @name       = safe_params[:name];
      @list       = @tournament.get_sorted_teams;
      @msg        = SmallNotice.new;
      @user       = current_user;

      #n will determine how many speakers we are building the team out of
      @n = GlobalConstants::FORMAT[:bp][:num_speakers_per_team];
      
      #check to see if the players existed
      #we have also generalized this accross debating formats
      users = [];
      (1..@n).each { |i|
         users.push(User.where(email: @emails[i-1]).first);
         #u[i] will be nil or a user object

         #might as well do error checking immediatley
         if users[i-1].nil?
            @msg.add(:error, "Could not find member #{i}.");
            render(render_place());
            return;
         end
      }

      #check memebrs are from same institution (in IF one day)
      #first get institution ids
      institution_ids = []
      users.each { |u|
         institution_ids.push(u.institution.id);
      }

      #if this is not from tabbie, 
      #if this is a capped/restricted tournament, the members have to be from the user's institution
      #if open, at least one member needs to be the current_user
      if render_place().split('/').last == "individual"
         if @tournament.tournament_setting[:registration] != 
            GlobalConstants::SETTINGS_VALUES[:registration]["Completely open"]
            institution_ids.each { |i|
               if i != @user.institution_id
                  @msg.add(:error, "You can only make teams for people in your institution.")
                  render(render_place());
                  return;
               end
            }
         else #completely open
            foundSelf = false; #assume self not in the list
            users.each { |u|
               if u == current_user
                  foundSelf = true;
               end
            }
            if !foundSelf
               @msg.add(:error, "You must be in the team you register")
               render(render_place());
               return;
            end
         end
      end

      #should only be one unique id if not an open tournament...
      #NEED TO INCORPORATE THE ABILITY TO HAVE PEOPLE FROM DIFF INST IF MANUAL REGO BUT STILL AND OPEN
      if institution_ids.uniq.count != 1
         @msg.add(:error, "Teams members are not from the same institution.");
         render(render_place());
         return;
      end

      #check users are in no other teams for this tournament
      #we think coming from the user side is better
      i = 1;
      users.each { |u|
         u.teams.each { |w|
            if w.tournament_id == @tournament.id
               @msg.add(:error, "Member #{i} is already competing in another team.");
               render(render_place());
               return;
            end
         }
         i = i + 1;
      }
      
      #check the users are not also adjs
      i = 1;
      users.each { |u|
         u.tournament_attendees.each { |w|
            if (w.tournament_id == @tournament.id) && 
               (w.role == GlobalConstants::TOURNAMENT_ROLES[:adjudicator])
               
               @msg.add(:error, "Member #{i} is already an adjudicator.");
               render(render_place());
               return;
            end
         }
         i = i + 1;
      }
      
      #at this point we will go a head and set up for saving
      @team = Team.new(name: safe_params[:name], institution_id: institution_ids[0],
                       tournament_id: @tournament.id, points: 0, total_speaks: 0);
      
      #generalized way to add in users, good for varribale number (2-3) speakers per team
      #which is needed for different formats of debating
      i = 1;
      users.each { |u|
         @team[("member_#{i}_id").to_sym] = u.id;
         i = i + 1;
      }

      if @team.save()
         #in this case, we must update the attendees table
         #actually, for now I don't think we need to ...
         
         #@msg.add(:success, "Team Created!"); #make sure the flash is below the form
         #redirect needs to use flash
         flash[:success] = "Team Created."
         redirect_to(redirect_place());
      else
         #so we need both flash and normal error rendering thing
         #lets fluralize the flash and then port over the error messages
         #while keeping an eye on what the 'shared/_error_messages' does
         
         load_errors(@team);
         render render_place();
         return;
      end
   end
   
   def show
      @team = Team.find(params[:id]);
   end

   def create
      #updeate attedees! ?
   end

   def edit
      @team = Team.find(params[:id]);
   end

   def update
      @team = Team.find(params[:id]);
      
      if @team.update_attributes(team_params);
         flash[:success] = "Team Updated!"
         redirect_to @team;
      else
         render 'edit';
      end
   end
   
   #this is pretty basic - just always ensure that a team is an 
   #entity of the tournament...it cannot stand alone.
   #if destroyed, destroyed to all - not a pick up and drop elsewhere object
   def destroy
      @team = Team.find(params[:id]);
      @team.destroy();
      redirect_to(user_path(current_user) + '/teams');
   end

   ### APPLY ALL SAME CHECKS FOR CREATE THAT APPLY
   def destroy_by_tabbie_or_user
      @team = Team.find(params[:team_id]);
      @team.destroy();
      redirect_to(redirect_place());
      return;
   end

   private
      #only a tabbie or member should be authorized for the team
      def authorized_for_team
         team = Team.find(params[:id]);
         redirect_to root_path unless team.users_ids.include?(current_user.id) || 
                                      current_user.in_tab_room?(team.tournament);
      end

      def authorized_for_make_team
         @tournament = Tournament.find(params[:id]);
         hasAuthority = (current_user.is_a_tabbie?(@tournament) ||
                         
                         (@tournament.tournament_setting[:registration] == 
                          GlobalConstants::SETTINGS_VALUES[:registration]["Completely open"]) ||
                         
                         (current_user.has_exec_position?([:president, :externals]) &&
                          (@tournament.tournament_setting[:registration] != 
                          GlobalConstants::SETTINGS_VALUES[:registration]["Manual"]) &&
                          !@tournament.has_maxed_out_teams(current_user.institution)));
         redirect_to root_path unless hasAuthority;
      end

      #this is true, if it is a member of the team and tournament hasn't started yet
      def edit_before_tournament_starts
         team = Team.find(params[:id])
         redirect_to root_path unless 
            (team.users_ids.include?(current_user.id) && 
               (team.tournament.status == GlobalConstants::TOURNAMENT_STATUS[:future]))
      end
      
      def team_params
         params.require(:team).permit(:name, :institution_id, :member_1, :member_2, :origin);
         #the :institution_id may come from selecting from a list (convenor does this) or by the users :id
      end
      
      #the other params not for Team
      def safe_params
         params.permit(:id, :name, :origin, :emails => []); #emails is an array
      end

      #we may call this from /control/teams or /registration/individual
      def render_place #returns the place to render based on origin
         if safe_params[:origin] == "individual"
            return 'tournaments/individual';
         elsif safe_params[:origin] == "teams"
            return 'tournaments/teams';
         else
            puts("Hack ###");
            redirect_to root_path;
            return;
         end
      end

      #we may call this from /control/teams or /registration/individual
      def redirect_place #returns the place to redirect to based on origin
         if safe_params[:origin] == "individual"
            return (tournament_path(@tournament) + '/registration/individual');
         elsif safe_params[:origin] == "teams"
            return (tournament_path(@tournament) + '/control/teams');
         else
            puts("Hack ###");
            redirect_to root_path;
            return;
         end
      end
   
end
