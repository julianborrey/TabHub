class TournamentsController < ApplicationController
   include TournamentsHelper
   
   before_action :signed_in_user, only: [:new, :create];
   before_action :authorized_for_tournament, only: [:destroy, :edit, :update, 
                                             :control, :tab_room, :rooms, 
                                             :import_rooms, :import_room,
                                             :remove_room, :rounds,
                                             :adjudicators, :teams,
                                             :edit_adj, :remove_adj];

   def index
      #make a has of lists of tournaments by region
      @list = {};
      @year_sum = 0;
      
      #we are entirely generalized off the globalconstants module
      GlobalConstants::TOURNAMENT_REGIONS.each { |key,val|
         @list[key] = Tournament.where(region: val).to_a;
         @year_sum = @year_sum + @list[key].count; #count up the number of tournaments
         #soon we will add year to the "where" filter above
         #for seperate index pages by year
      }
   end

   def new
      @tournament = Tournament.new();
      @tournament.tournament_setting = TournamentSetting.new();
   end
   
   def create
      puts("Creating tuornament");
      @tournament = Tournament.new(tournament_params);
      #@tournament.tournament_setting = TournamentSetting.new(tournament_params);
      #@setting    = TournamentSetting.new(setting_params);
      
      puts("in creat there si: " + @tournament.tournament_setting.motion.to_s)
      u = current_user;
      @tournament.user_id = u.id;
      @tournament.institution_id = u.institution_id;
      @tournament.status = GlobalConstants::TOURNAMENT_STATUS[:future]; #starts not begun (naturally)
      @tournament.rooms = [];
      
      if @tournament.save()
         #need to set this person as authorized at least
         TournamentAttendee.new(tournament_id: @tournament.id, user_id: u.id,
                                role: GlobalConstants::TOURNAMENT_ROLES[:tab_room]).save;
         
         redirect_to(tournament_path(@tournament));
      else
         render 'tournaments/new';
      end
   end
   
   def show
      if Tournament.exists?(params[:id])
         @tournament = Tournament.find(params[:id]);
         @user = nil || current_user;
      else
         redirect_to tournaments_path;
      end
   end

   def edit
      @tournament = Tournament.find(params[:id]);
   end

   def update
      @tournament = Tournament.find(params[:id]);
      
      if @tournament.update_attributes(tournament_params);
         flash[:success] = "Tournament Updated!"
         redirect_to @tournament;
      else
         render 'edit';
      end
   end
   
   def destroy
   end
   
   #control panel page
   def control
      @tournament = Tournament.find(params[:id]);
      @roomCheck = @tournament.enough_rooms;
      @multiple4Check = @tournament.multiple4Check;
      @enoughAdj = @tournament.enoughAdj;
      @ballotCheck = @tournament.ballotCheck;
      
      @totalCheck = [@roomCheck[0], @multiple4Check[0], 
                     @ballotCheck[0], @enoughAdj[0]].all?
      if @totalCheck
         @totalCheck = [@totalCheck, "#33cc33", "Ready"];
      else
         @totalCheck = [@totalCheck, "red", "Not Ready"];
      end
   end

   #attendees page function
   def attendees
      @tournament = Tournament.find(params[:id]);
   end

   #stats page method
   def stats
      @tournament = Tournament.find(params[:id]);
      @ranked_list = @tournament.get_ranked_list_from_only_points(); #sort teams in desending order
   end
   
   #tab_room page shows authorized users
   def tab_room
      @tournament = Tournament.find(params[:id]);
      @tab_room_attendee_array = @tournament.tabbies;
      @temp_email = "";
   end
   
   #rednders the rooms page
   def rooms
      @tournament = Tournament.find(params[:id]);
      @room       = Room.new();
      @flash = [];
   end
   
   def import_rooms
      @tournament = Tournament.find(params[:id]);
   end

   def import_room
      t = Tournament.find(safe_import_room_params[:id]);
      
      #check not duplicate
      room_id = safe_import_room_params[:room_id].to_i;
      if !t.rooms.include?(room_id)
         
         #check this room does infact belong to the institution
         if t.institution.rooms.include?(Room.find(room_id))
            t.update_attributes(rooms: t.rooms.push(room_id));
         end

      end

      render nothing: true;
   end

   def remove_room
      t = Tournament.find(safe_import_room_params[:id]);
      
      #check the link exists
      room_id = safe_import_room_params[:room_id].to_i;
      if t.rooms.include?(room_id)
         t.rooms.delete(room_id)
         t.save();
      end
      
      render nothing: true;
   end
   
   ### seriously one day I need to actually work hacks
   #   can be done with params. Look at input for rounds()
   #   and remove_room(). (one without safe and one with)
   # also, should @t = T.find() be abstracted? (private foo?)
   
   def rounds
      @tournament = Tournament.find(params[:id]);
      @round = Round.new();
      @round.motion = Motion.new();
   end
   
   def adjudicators
      flash.clear;
      @tournament = Tournament.find(params[:id]);
      @ta = TournamentAttendee.new();
      @temp_email = "";
   end

   #renders page to edit adj rating and conflicts
   def edit_adj
      flash = {};
      @tournament     = Tournament.find(params[:id]);
      @ta             = TournamentAttendee.find(params[:ta_id]);
      @user           = @ta.user;
      @conflicts_list = @user.conflicts.to_a;
      @conflict       = Conflict.new;
   end
   #two things could be updated here
   #1. TournamentAttendee.rating
   #2. Conflicts entries
   #Let us use two forms on one page, redirect back to edit page.
   #Have a done button on the edit page to go back
   #We will post directly to the normal RESOURCES
   #but the edit page will be hosted by tournaments
   
   #post will activate this method to remove adj from tournament
   #movet this? -- its probably fine here.
   def remove_adj
      ta = TournamentAttendee.find(params[:ta_id].to_i); #should already by role = adj
      puts(" helpopppppppppppppppp: " + ta.role.to_s + " sadas " + ta.id.to_s);
      #check this is in fact an adj TA
      #if ta.role == GlobalConstants::TOURNAMENT_ROLES[:adjudicator]
         ta.destroy();
      #end
      redirect_to(tournament_path(params[:id].to_i) + '/control/adjudicators');
   end

   #shows the teams
   #tabbie can add/remove teams here --> edit on another page
   def teams
      @tournament = Tournament.find(params[:id]);
      flash = {};

      ### for the new form ###
      @n = GlobalConstants::FORMAT[:bp][:num_speakers_per_team];
      @name   = "";
      @emails = [];
      (1..@n).each { |i|
         @emails.push("");
      } #start off with correct number of blank emails
      
      ### for the table of teams ###
      #build a list of institutionally (alphabetical) ordered teams
      # *** will be interesting to try this with 100 teams (small tournament)
      # 400 (WUDC) and 1000 (wtf...)
      @list = @tournament.get_sorted_teams;
   end
   
   
   private
      def tournament_params
         params.require(:tournament).permit(:name, :institution_id, :location, 
         :start_time, :end_time, :remarks, tournament_setting_attributes: 
         [:motion, :tab, :registration, :privacy, :attendees, :teams]);
         #the :institution_id may come from selecting from a list (convenor does this) or by the users :id
      end

      def safe_import_room_params
         params.permit(:room_id, :id)
      end
      
end
