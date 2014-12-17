class TournamentsController < ApplicationController
	include ApplicationHelper
   include TournamentsHelper
   
   before_action :redirect_if_not_signed_in, only: [:new, :create, :register_submission, :individual];
   before_action :authorized_for_tournament, only: [:destroy, :edit, :update, 
		                                              :control, :tab_room, :rooms, 
		                                              :import_rooms, :import_room,
		                                              :remove_room, :rounds,
		                                              :adjudicators, :teams,
		                                              :edit_adj, :remove_adj];
   before_action :check_not_manual_tournament, only: [:individual, :register_submission];
   before_action :authorized_for_institution, only: [:individual];
   before_action :authorized_for_rounds, only: [:rounds]
   before_action :authorized_for_start_next_close_tournament, only: [:start_tournament, :close_tournament, :next_round]

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
      puts("Creating Tournament");
      @tournament = Tournament.new(tournament_params);
      #@tournament.tournament_setting = TournamentSetting.new(tournament_params);
      #@setting    = TournamentSetting.new(setting_params);
      
      u = current_user;
      @tournament.user_id = u.id;
      @tournament.institution_id = u.institution_id;
      @tournament.status = GlobalConstants::TOURNAMENT_STATUS[:future]; #starts not begun (naturally)
      @tournament.rooms = [];
      @tournament.round_counter = -1; #start in the pre-rego stage
      @tournament.progress = 0; #have not made a draw yet
      
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
   	@user = current_user;
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
      @round = Round.new();
      @round.motion = Motion.new();
   end
   
   def adjudicators
      @tournament = Tournament.find(params[:id]);
      @temp_email = "";
   end
   
   #shows the teams
   #tabbie can add/remove teams here --> edit on another page
   def teams
      @tournament = Tournament.find(params[:id]);

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
   
   #rendering what all institutions are bring with just numbers
   def institutions
      @tournament = Tournament.find(params[:id]);
      
      #make a hash of ellements of the following:
      #{id: integer, num_teams: integer, 
      # num_adjs: integer, num_tabbies: integer}
      #with inst_short name as keys
      
      @list = {};
      
      #home that short name is sanitized!
      #O(n) time --> yay!
         
      @tournament.tournament_attendees.each { |ta|
         #check if and array for this institution even exists yet
         if @list[ta.user.institution.short_name.to_sym].nil?   #nope
            @list[ta.user.institution.short_name.to_sym] = {id: ta.user.institution.id, allocated_teams: 0,
                                                            allocated_adjs: 0, num_teams: 0, 
                                                            adjudicator: 0, tab_room: 0, dca: 0, ca: 0};  #make array
         end
         
         #do the counting
         GlobalConstants::TOURNAMENT_ROLES.each { |role,val|
            if ta.role == GlobalConstants::TOURNAMENT_ROLES[role]
               @list[ta.user.institution.short_name.to_sym][role] = 
                  @list[ta.user.institution.short_name.to_sym][role] + 1; #add to array
            end
         }
      }
      
      #now count the teams
      @tournament.teams.each { |t|
         if @list[t.institution.short_name.to_sym].nil?   #nope
            @list[t.institution.short_name.to_sym] = {id: t.institution.id, allocated_teams: 0,
                                                            allocated_adjs: 0, num_teams: 0, 
                                                            adjudicator: 0, tab_room: 0, dca: 0, ca: 0};  #make array
         end
         
         @list[t.institution.short_name.to_sym][:num_teams] = 
            @list[t.institution.short_name.to_sym][:num_teams] + 1;
      }
      
      #now we check for allocations
      @tournament.allocations.each { |a|
         if @list[a.institution.short_name.to_sym].nil?   #nope
            @list[a.institution.short_name.to_sym] = {id: a.institution.id, allocated_teams: 0,
                                                            allocated_adjs: 0, num_teams: 0, 
                                                            adjudicator: 0, tab_room: 0, dca: 0, ca: 0};  #make array
         end
         
         @list[a.institution.short_name.to_sym][:allocated_adjs] = a.num_adjs;
         @list[a.institution.short_name.to_sym][:allocated_teams] = a.num_teams;
      }
      #that should be it...
   end
   
   #post to this will allow for users to register
   def open_rego
      @tournament = Tournaments.find(params[:id]);
      @tournament.update_attributes(round_counter: GlobalConstants::TOURNAMENT_PHASE[:open_rego]);
      redirect_to tournament_path(@tournament);
   end
   
   #post to this will close registration for users
   def close_rego
      @tournament = Tournaments.find(params[:id]);
      @tournament.update_attributes(round_counter: GlobalConstants::TOURNAMENT_PHASE[:closed]);
      redirect_to tournament_path(@tournament);
   end

   #post to /control/start which changes state from future to present
   def start_tournament
   	#check tournament is yet to be started
   	if @tournament[:status] == GlobalConstants::TOURNAMENT_STATUS[:future]
   		@tournament.update(status: GlobalConstants::TOURNAMENT_STATUS[:present]);
   		redirect_to (tournament_path(@tournament) + '/control');
   		return;
   	else #if it was ... hack
   		puts("HACK ###");
   	end
   	redirect_to root_path
   	return;
   end

   #post to /control/close which changes state from present to past
   def close_tournament
   	#check tournament is yet to be closed
   	if @tournament[:status] == GlobalConstants::TOURNAMENT_STATUS[:present]
   		@tournament.update(status: GlobalConstants::TOURNAMENT_STATUS[:past]);
   		redirect_to (tournament_path(@tournament) + '/control');
   		return;
   	else #if it was ... hack
   		puts("HACK ###");
   	end
   	redirect_to root_path
   	return;
   end

   #need to check that the tournament is not manual - before_action
   #shows page for users to register their teams
   def individual
      @user = current_user
   end

   private
      def tournament_params
         params.require(:tournament).permit(:name, :institution_id, :location, 
         :start_time, :end_time, :remarks, :region, tournament_setting_attributes: 
         [:motion, :tab, :registration, :privacy, :attendees, :teams]);
         #the :institution_id may come from selecting from a list (convenor does this) or by the users :id
      end

      def safe_import_room_params
         params.permit(:room_id, :id)
      end

      def safe_register_team_by_user_params
         params.permit(:name, :emails => []);
      end

      def authorized_for_institution
         @tournament = Tournament.find(params[:id]);
         openTournament = (@tournament.tournament_setting.registration == 
                      GlobalConstants::SETTINGS_VALUES[:registration]["Completely open"]);

         redirect_to tournament_path(params[:id]) unless 
            (openTournament || current_user.has_exec_position?([:president, :externals]));
      end

      def authorized_for_rounds
      	@tournament = Tournament.find(params[:id]);
         redirect_to illegal_access_path(:motions) unless current_user.is_in_roles?([:ca, :dca], @tournament);
      end

      def check_not_manual_tournament
         @tournament = Tournament.find(params[:id]);

         redirect_to tournament_path(params[:id]) unless 
         (!@tournament.nil? &&
         (@tournament.tournament_setting.registration != GlobalConstants::SETTINGS_VALUES[:registration]["Manual"]));
      end

      def authorized_for_start_next_close_tournament
      	@tournament = Tournament.find(params[:id]);
      	redirect_to illegal_access_path(:tournament_state) unless current_user.is_in_roles?([:ca], @tournament);
      end
end
