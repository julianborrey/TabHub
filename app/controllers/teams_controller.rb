class TeamsController < ApplicationController
   before_action :signed_in_user, only: [:show, :new, :create]
   #before_action :authorized_for_team, only: [:destroy, :edit, :update]
   
   def new
      @team = Team.new();
   end
   
   def create
      @team = Team.new(team_params);
      @team[:points] = 0; #initialize
      @team[:total_speaks] = 0;

      if @team.save()
         flash[:success] = "Team Created!"
         redirecit_to(team_path(@team));
      else
         render 'team/new';
      end
   end
   
   def show
      @team = Team.find(params[:id]);
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
   
   def destroy
   end

   private
      def team_params
         params.require(:team).permit(:name, :institution_id, :member_1, :member_2);
         #the :institution_id may come from selecting from a list (convenor does this) or by the users :id
      end
   
end
