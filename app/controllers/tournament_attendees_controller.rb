class TournamentAttendeesController < ApplicationController
   include TournamentsHelper

   before_action :authorized_for_tournament, only: [:destroy, :create];
   
   def create_tabbie_by_tabbie
      newTabbie = User.where(email: safe_params[:email]).first;
      
      @tournament = Tournament.find(params[:id]);
      @temp_email = safe_params[:email]; #need this incase we render
      @tab_room_attendee_array = TournamentAttendee.where(tournament_id: @tournament.id,
                                       role: GlobalConstants::TOURNAMENT_ROLES[:tab_room]);
      @msg                     = SmallNotice.new;
      
      #if we couldn't find the user
      if newTabbie.nil?
         @msg.add(:error, "Counld not find the user.");
         render('tournaments/tab_room');
         return;
      end
      
      
      @ta = TournamentAttendee.new(tournament_id: params[:id], user_id: newTabbie.id,
                                   role: GlobalConstants::TOURNAMENT_ROLES[:tab_room]);
      
      if @ta.save                       
         #complete; if user same, just redirect anyway. no point putting error message
         flash[:success] = "User added to tab room."
         redirect_to(tournament_path(@tournament) + '/control/tab-room');
      else
         @ta.errors.full_messages.each { |m|
            @msg.add(:error, m);
         }
         render 'tournaments/tab_room';
         return;
      end
   end
   
   def destroy_by_tabbie
      @ta = TournamentAttendee.find(params[:ta_id]);
      @ta.destroy();
      redirect_to(tournament_path(params[:id]) + '/control/tab-room');
   end

=begin   
   def create
      #@temp_email = safe_params[:email]
      
      ### more sanitation would be here ###
       
      #first, work out where the request is coming from
      #if from tab room to add to tab room
         #check for current_user actually being in tab room
         #then search the email
         #then try to make the user
      t = Tournament.find(safe_params[:tournament_id].to_i);

      if safe_params[:request_origin] == "tab_room"
         
      elsif safe_params[:request_origin] == "adjudicators" #if adding an adj
         newAdj = User.where(email: safe_params[:email]);
         
         #check that the user was found, if not error
         if !newAdj.empty?
            newAdj = newAdj.first;
            
            if !newAdj.adj?(t) #duplicate check
               newAdj.teams.each { |t| #check to make sure they are also not a debater
                  if t.tournament_id == t.id
                     flash[:error] = "User not found."
                     @temp_email = safe_params[:email];
                     @tournament = t;
                     @ta = TournamentAttendee.new;
                     render('tournaments/adjudicators');
                  end
               }

               TournamentAttendee.new(tournament_id: t.id,
                                      user_id: newAdj.id,
                                      rating: safe_params[:rating],
                                      role: GlobalConstants::TOURNAMENT_ROLES[:adjudicator]).save;
            end
            redirect_to(tournament_path(t) + '/control/adjudicators');
         else
            flash[:error] = "User not found."
            @temp_email = safe_params[:email];
            @tournament = t;
            @ta = TournamentAttendee.new;
            render('tournaments/adjudicators');
         end
      end
   end
=end

   #so far, update is purely for adj ratings and the only place 
   #this can happen is from the edit of an adj on the control panel
   def update
      ta = TournamentAttendee.find(params[:id]);
      ta.update_attributes(rating: params[:tournament_attendee][:rating].to_f);
      flash[:success] = "Updated adjudicator rating successfully."
      redirect_to(tournament_path(ta.tournament_id) + '/control/adjudicators/' + ta.id.to_s + '/edit');
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
         params.permit(:email, :rating);
      end
   
end
