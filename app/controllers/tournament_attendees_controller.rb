class TournamentAttendeesController < ApplicationController
   include TournamentsHelper

   before_action :authorized_for_tournament, only: [:destroy, :create];
   
   def create_tabbie_by_tabbie
      @temp_email = safe_params[:email]; #need this incase we render
      newTabbie   = User.where(email: @temp_email).first;
      @tournament = Tournament.find(params[:id]);
      @tab_room_attendee_array = TournamentAttendee.where(tournament_id: @tournament.id,
                                       role: GlobalConstants::TOURNAMENT_ROLES[:tab_room]);
      @msg                     = SmallNotice.new;
      
      #if we couldn't find the user
      if !check_found_user(newTabbie, 'tournaments/tab_room');
         return;
      end
      
      @ta = TournamentAttendee.new(tournament_id: params[:id], user_id: newTabbie.id,
                                   role: GlobalConstants::TOURNAMENT_ROLES[:tab_room]);
      
      if @ta.save                       
         #complete; if user same, just redirect anyway. no point putting error message
         flash[:success] = "User added to tab room."
         redirect_to(tournament_path(@tournament) + '/control/tab-room');
      else
         load_errors(@ta);
         render 'tournaments/tab_room';
         return;
      end
   end
   
   def destroy_tabbie_by_tabbie
      @tournament = Tournament.find(params[:id]);

      #check the they are not the last tabbie
      #that would lock the tournament!
      if @tournament.tabbies.count > 1
         @ta = TournamentAttendee.find(params[:ta_id]);
         @ta.destroy();
         flash[:success] = "User removed from tab room.";
         redirect_to(tournament_path(params[:id]) + '/control/tab-room');
      else
         @msg = SmallNotice.new;
         @msg.add(:error, "You must have at least 1 person in the tab room.");
         render('tournaments/tab_room');
      end
   end
   
   def create_adj_by_tabbie
      @temp_email = safe_params[:email]; #need this incase we render
      newAdj = User.where(email: @temp_email).first;
      @tournament = Tournament.find(params[:id]); 
      @tab_room_attendee_array = TournamentAttendee.where(tournament_id: @tournament.id,
                                       role: GlobalConstants::TOURNAMENT_ROLES[:tab_room]);
      @msg                     = SmallNotice.new;
      
      if !check_found_user(newAdj, 'tournaments/adjudicators');
         return;
      end
      
      newAdj.teams.each { |t| #check to make sure they are also not a debater
         if t.tournament_id == @tournament.id
            @msg.add(:error, "This user is already a debater in this tournament.");
            render('tournaments/adjudicators');
            return;
         end
      }
      
      @ta = TournamentAttendee.new(tournament_id: @tournament.id,
                                   user_id: newAdj.id,
                                   rating: safe_params[:rating],
                                   role: GlobalConstants::TOURNAMENT_ROLES[:adjudicator]);
      if @ta.save
         flash[:success] = "Adjudicator added."
         redirect_to(tournament_path(@tournament) + '/control/adjudicators');
      else
         puts("AND HERERERERE");
         load_errors(@ta);
         render('tournaments/adjudicators');
      end
   end
   
   #renders page to edit adj rating and conflicts
   def edit_adj_by_tabbie
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
   
   #so far, update is purely for adj ratings and the only place 
   #this can happen is from the edit of an adj on the control panel
   def update_adj_by_tabbie
      ta = TournamentAttendee.find(params[:id]);
      ta.update_attributes(rating: params[:tournament_attendee][:rating].to_f);
      flash[:success] = "Updated adjudicator's rating successfully."
      redirect_to(tournament_path(ta.tournament_id) + '/control/adjudicators/' + ta.id.to_s + '/edit');
   end

   #no check on how many adjs
   def destroy_adj_by_tabbie
      @ta = TournamentAttendee.find(params[:ta_id]);
      @ta.destroy();
      flash[:success] = "Adjudicator removed from tournament.";
      redirect_to(tournament_path(params[:id]) + '/control/adjudicators');
   end
   
   private
      def safe_params
         params.permit(:email, :rating);
      end
      
      #if we couldn't find user we render
      def check_found_user(u, path)
         if u.nil?
            @msg.add(:error, "Counld not find the user.");
            render(path);
            return false;
         end
         return true;
      end
      
      def load_errors(obj)
         puts("CHECKEKECKECE");
         obj.errors.full_messages.each { |m|
            @msg.add(:error, m);
         }
      end
      
end
