class TournamentsController < ApplicationController
   before_action :signed_in_user, only: [:show, :new, :create]
   #before_action :authorized_for_tournament, only: [:destroy, :edit, :update]
   
   def new
      @tournament = Tournament.new();
   end
   
   def create
      @tournament = Tournament.new(tournament_params);

      if @tournament.save()
         flash[:success] = "Tournament Created!"
         redirecit_to(tournament_path(@tournament));
      else
         render 'tournament/new';
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

   private
      def tournament_params
         params.require(:tournament).permit(:name, :institution_id, :location, :start_time, :end_time, :remarks);
         #the :institution_id may come from selecting from a list (convenor does this) or by the users :id
      end
   
end
