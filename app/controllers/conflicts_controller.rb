class ConflictsController < ApplicationController
   #but through other pages the conflicts may be edited
   before_action :authorized_for_conflicts, only: [:create]

   def create
      puts("safe_p: " + safe_params.to_s);
      @conflict = Conflict.new(user_id: safe_params[:user_id],
                               institution_id: safe_params[:conflict][:institution_id]);
      
      @conflict.save #if save successful (doesn't return false/nil)
      #since this is hard coded input, not error things
      #even if there was an error, what will we tell the user???
      
      #need to go back to the origin
      redirect_to(params[:request_origin]); #is this dangerous?
   end
   
   #you know, I think no destroys for now...
   #def destroy
   #   @conflict = Conflict.find(params[:id]);
   #   if @conflict.from_current_institution? #if so, we will not delete it
   #      flash[:error] = "Your cannot delete your current institution as a conflict."
   #      #something cool to implement one day will be to run an algoritm to tell the
   #      #tab room (make a notice board) if the user has participated in a tournament
   #      #as another institution than their current one and they don't have that other 
   #      #insittution currently as a conflict. Means they had to have deleted it.
   #      #this site would have to have been runnin a few years first
   #   else
   #      flash[:error] = ""
   #   end
   #end

   private
      #true if the request is from tournament.tabRoom ppl or is the user of this conflict
      def authorized_for_conflicts
         conflict_user = User.find(params[:user_id].to_i);
         redirect_to root_path unless ((conflict_user.id == current_user.id) || (current_user.in_tab_room_of?(conflict_user)))
      end
      
      def safe_params
         params.permit(:user_id, conflict: [:institution_id]);
      end
   
end
