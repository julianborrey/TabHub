class TournamentAttendeesController < ApplicationController
   include TournamentsHelper
   
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
         
         #just check they didn't do them self and duplicate their attendee entry
         ##### should probs make these unique
         if !newTabbie.empty?
            newTabbie = newTabbie.first;
            
            if newTabbie.id != current_user.id
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
   end
   
   private
      def safe_params
         params.permit(:email, :tournament_id, :request_origin, :utf8, :authenticity_token, :commit);
      end
   
end
