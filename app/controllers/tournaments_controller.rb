class TournamentsController < ApplicationController
   include TournamentHelper
   
   before_action :signed_in_user, only: [:show, :new, :create];
   before_action :authorized_for_tournament, only: [:destroy, :edit, :update, :control]; 
   
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
      @tab_room_attendee_array = TournamentAttendee.where(tournament_id: @tournament.id, 
                                 role: GlobalConstants::TOURNAMENT_ROLES[:tab_room]);
      @temp_email = "";
   end
   
   #rednders the rooms page
   def rooms
      @tournament = Tournament.find(params[:id]);
      @room       = Room.new();
   end

   private
      def tournament_params
         params.require(:tournament).permit(:name, :institution_id, :location, 
         :start_time, :end_time, :remarks, tournament_setting_attributes: 
         [:motion, :tab, :registration, :privacy, :attendees, :teams]);
         #the :institution_id may come from selecting from a list (convenor does this) or by the users :id
      end
      
end
