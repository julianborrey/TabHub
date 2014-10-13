class TournamentAttendeesController < ApplicationController
   include ApplicationHelper
   include TournamentsHelper

   before_action :user_signed_in?
   before_action :authorized_for_tournament, only: [:destroy_tabbie_by_tabbie, :create_tabbie_by_tabbie];
   before_action :authorized_for_making_adj, only: [:create_adj_by_tabbie_or_user,
                                                     :destroy_adj_by_tabbie_or_user];
   
   def create_tabbie_by_tabbie
      @temp_email = safe_params[:email]; #need this incase we render
      newTabbie   = User.where(email: @temp_email).first;
      @tournament = Tournament.find(params[:id]);
      @msg        = SmallNotice.new;
      
      #if we couldn't find the user
      if !check_found_user(newTabbie, 'tournaments/tab_room');
         return;
      end
      
      @ta = TournamentAttendee.new(tournament_id: params[:id], user_id: newTabbie.id,
                                   role: safe_params[:role][:role_id], institution_id: newTabbie.institution_id);
      
      if @ta.save                       
         #complete; if user same, just redirect anyway. no point putting error message
         flash[:success] = "User added to tab room."
         redirect_to(tournament_path(@tournament) + '/control/tab-room');
      else
         load_errors(@ta);
         render 'tournaments/tab_room';
         return;
      end
   end
   
   def destroy_tabbie_by_tabbie
      @tournament = Tournament.find(params[:id]);

      #check the they are not the last tabbie
      #that would lock the tournament!
      if @tournament.tabbies.count > 1
         @ta = TournamentAttendee.find(params[:ta_id]);
         @ta.destroy();
         flash[:success] = "User removed from tab room.";
         redirect_to(tournament_path(params[:id]) + '/control/tab-room');
      else
         @msg = SmallNotice.new;
         @msg.add(:error, "You must have at least 1 person in the tab room.");
         render('tournaments/tab_room');
      end
   end
   
   def create_adj_by_tabbie_or_user
      @user = current_user;
      @temp_email = safe_params[:email]; #need this incase we render
      newAdj = User.where(email: @temp_email).first;
      @tournament = Tournament.find(params[:id]); 
      @tab_room_attendee_array = TournamentAttendee.where(tournament_id: @tournament.id,
                                       role: GlobalConstants::TOURNAMENT_ROLES[:tab_room]);
      @msg                     = SmallNotice.new;
      
      if !check_found_user(newAdj, render_place());
         return;
      end
      
      #check to make sure the person they have submitted is in their institution
      #if this is not a tabbie doing the job
      if !current_user.is_a_tabbie?(@tournament) && (newAdj.institution_id != current_user.institution_id)
         @msg.add(:error, "You can only submit someone from your own institution.");
         render(render_place());
         return;
      end

      #check to make sure they are also not a debater
      newAdj.teams.each { |t|
         if t[:tournament_id] == @tournament[:id]
            @msg.add(:error, "This user is already a debater in this tournament.");
            render(render_place());
            return;
         end
      }
      
      maybeGivenRating = 0;
      if current_user.is_a_tabbie?(@tournament) #if a tabbie submitting
         maybeGivenRating = safe_params[:rating]; #if they gave it
      end

      @ta = TournamentAttendee.new(tournament_id: @tournament.id,
                                   user_id: newAdj.id,
                                   rating: maybeGivenRating,
                                   institution_id: newAdj.institution_id,
                                   role: GlobalConstants::TOURNAMENT_ROLES[:adjudicator]);
      if @ta.save
         flash[:success] = "Adjudicator added."
         redirect_to(redirect_place());
      else
         load_errors(@ta);
         render(render_place());
      end
   end
   
   #renders page to edit adj rating and conflicts
   def edit_adj_by_tabbie
      @tournament     = Tournament.find(params[:id]);
      @ta             = TournamentAttendee.find(params[:ta_id]);
      @user           = @ta.user;
      @conflicts_list = @user.conflicts.to_a;
   end
   #two things could be updated here
   #1. TournamentAttendee.rating
   #2. Conflicts entries
   #Let us use two forms on one page, redirect back to edit page.
   #Have a done button on the edit page to go back
   #We will post directly to the normal RESOURCES
   #but the edit page will be hosted by tournaments
   
   #so far, update is purely for adj ratings and the only place 
   #this can happen is from the edit of an adj on the control panel
   def update_adj_by_tabbie
      @ta = TournamentAttendee.find(params[:ta_id]);
      
      if @ta.update_attributes(rating: params[:tournament_attendee][:rating].to_f);
         flash[:success] = "Updated adjudicator's rating successfully."
         redirect_to(tournament_path(@ta.tournament_id) + '/control/adjudicators/' + @ta.id.to_s + '/edit');
      else
         @tournament     = Tournament.find(params[:id]);
         @user           = @ta.user;
         @conflicts_list = @user.conflicts.to_a;
         @msg            = SmallNotice.new;
         load_errors(@ta);
         render(tournament_path(@tournament) + 'control/adjudicators/' + @ta.id + '/edit');
      end
   end

   ### APPLY ALL SAME CHECKS FOR CREATE THAT APPLY
   #no check on how many adjs
   def destroy_adj_by_tabbie_or_user
      @user = current_user;
      @ta = TournamentAttendee.find(params[:ta_id]);
      @ta.destroy();
      flash[:success] = "Adjudicator removed from tournament.";
      redirect_to(redirect_place);
   end
   
   private
      def safe_params
         params.permit(:email, :rating, :origin, role: [:role_id]);
      end
      
      #if we couldn't find user we render
      def check_found_user(u, path)
         if u.nil?
            @msg.add(:error, "Counld not find the user.");
            render(path);
            return false;
         end
         return true;
      end
      
      #we may call this from /control/teams or /registration/individual
      def render_place #returns the place to render based on origin
         if safe_params[:origin] == "individual"
            return 'tournaments/individual';
         elsif safe_params[:origin] == "adjudicators"
            return 'tournaments/adjudicators';
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
         elsif safe_params[:origin] == "adjudicators"
            return (tournament_path(params[:id]) + '/control/adjudicators');
         else
            puts("Hack ###");
            redirect_to root_path;
            return;
         end
      end

      #this function has to check mutliple cases
      #if tabbie, just go ahead
      #if open rego, need to check they are registering them selves
      #if user, check they are within the cap and they are submitting an adj,
      #no other role
      def authorized_for_making_adj
         @tournament = Tournament.find(params[:id]);
         hasAuthority = (current_user.is_a_tabbie?(@tournament) ||
                         
                         ((@tournament.tournament_setting[:registration] == 
                          GlobalConstants::SETTINGS_VALUES[:registration]["Completely open"]) &&
                          (safe_params[:email] == current_user.email)) ||
                         
                         (current_user.has_exec_position?([:president, :externals]) &&
                          (@tournament.tournament_setting[:registration] != 
                          GlobalConstants::SETTINGS_VALUES[:registration]["Manual"]) &&
                          !@tournament.has_maxed_out_adjs(current_user.institution)));
         redirect_to root_path unless hasAuthority;
      end
end
