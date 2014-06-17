class TournamentAttendeesController < ApplicationController
   include TournamentHelper

   before_action :authorized_for_tournament, only: [:destroy, :create];

   def create
      #@temp_email = safe_params[:email]
      
      ### more sanitation would be here ###
       
      #first, work out where the request is coming from
      #if from tab room to add to tab room
         #check for current_user actually being in tab room
         #then search the email
         #then try to make the user
      if safe_params[:request_origin] == "tab_room"
         newTabbie = User.where(email: safe_params[:email]);
         
         #just check they didn't duplicate their attendee entry
         ##### should probs make these unique
         if !newTabbie.empty?
            newTabbie = newTabbie.first;
            
            t = Tournament.find(safe_params[:tournament_id]);
            if !newTabbie.in_tab_room?(t) #duplication check
               TournamentAttendee.new(tournament_id: safe_params[:tournament_id],
                                      user_id: newTabbie.id,
                                      role: GlobalConstants::TOURNAMENT_ROLES[:tab_room]).save;
            end
            
            #complete; if user same, just redirect anyway. no point putting error message
            redirect_to(tournament_path(safe_params[:tournament_id]) + '/control/tab-room');
         else
            puts("user not found");
            flash[:error] = "User not found.";
            @tournament = Tournament.find(safe_params[:tournament_id]);
            @tab_room_attendee_array = TournamentAttendee.where(tournament_id: @tournament.id,
                                       role: GlobalConstants::TOURNAMENT_ROLES[:tab_room]);
            @temp_email = safe_params[:email];
            render('tournaments/tab_room');
         end
      end
   end
   
   def destroy
      #checking they are authorized for the tournament isn't enough
      #need to also be sure they are part of the tab_room they are editing
      a = TournamentAttendee.find(params[:id]);
      t = Tournament.find(a.tournament_id); #get the tournament of interest
      if current_user.in_tab_room?(t) #subtle
         if TournamentAttendee.where(tournament_id: t.id).count > 1 #check not the last tabbie
            a.destroy();
         else
            flash[:error] = "You must have at least one person in the tab room."
         end
      end
      redirect_to(tournament_path(safe_params[:tournament_id]) + '/control/tab-room');
   end
   
   private
      def safe_params
         params.permit(:email, :tournament_id, :request_origin, :utf8, :authenticity_token, :commit);
      end
   
end
