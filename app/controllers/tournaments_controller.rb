class TournamentsController < ApplicationController
   before_action :signed_in_user, only: [:show, :new, :create];
   before_action :authorized_for_tournament, only: [:destroy, :edit, :update, :control];
   
   def new
      @tournament = Tournament.new();
   end
   
   def create
      @tournament = Tournament.new(tournament_params);
      u = current_user;
      @tournament.user_id = u.id;
      @tournament.institution_id = u.institution_id;
      @tournament.status = GlobalConstants::TOURNAMENT_STATUS[:future]; #starts not begun (naturally)

      if @tournament.save()
         #need to set this person as authorized at least
         TournamentAttendee.new(tournament_id: @tournament.id, user_id: u.id,
                                role: GlobalConstants::TOURNAMENT_ROLES[:tab_room]).save;
         
         flash[:success] = "Tournament Created!"
         redirect_to(tournament_path(@tournament));
      else
         render 'tournaments/new';
      end
   end
   
   def show
      @tournament = Tournament.find(params[:id]);
      @user = nil || current_user;
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

   private
      def tournament_params
         params.require(:tournament).permit(:name, :institution_id, :location, :start_time, :end_time, :remarks);
         #the :institution_id may come from selecting from a list (convenor does this) or by the users :id
      end

      #checks that the user is authorized to view ctrlPanel or edit tournament (tabRoom power)
      def authorized_for_tournament
         @t = Tournament.find(params[:id]);
         redirect_to tournament_path(@t) unless current_user.in_tab_room?(@t);
      end
   
end
