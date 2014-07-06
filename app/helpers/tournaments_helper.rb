module TournamentsHelper

   def get_user_attendence(user)
      if user.nil? #if not signed in
         return nil; #no user to be attending
      end
      
      user_list = {past: [], present: [], future: []};

      #get most current if exists
      user.tournament_attendees.each { |t| #check each tournament
         if !t.tournament.nil? #would occur if db broke or tournament go deleted (NEVER!)
            if t.tournament.status == GlobalConstants::TOURNAMENT_STATUS[:past] #if in the past
               user_list[:past].push(t);
            end
            
            if t.tournament.status == GlobalConstants::TOURNAMENT_STATUS[:present] #if currently attneding one
               user_list[:present].push(t);
            end
            
            if t.tournament.status == GlobalConstants::TOURNAMENT_STATUS[:future] #if coming up
               user_list[:future].push(t);
            end
         end
      }
      
      return user_list;
   end

   #return an hash of arrays which give role and positions of such
   ### we will get to this...its a lot of work
   def tourn_listing_wrapper(user)
      user_list = get_user_tourns(user); #get the list
      
      listing = {}; #rtn value
      
   end
   
   #checks that the user is authorized to view ctrlPanel or edit tournament (tabRoom power)
   def authorized_for_tournament
      id = params[:tournament_id] || params[:id]
      if !id.is_a?(Fixnum)
         id = id.to_i;
      end
      @t = Tournament.find(id);
      redirect_to tournament_path(@t) unless current_user.is_in_roles?([:tab_room, :ca, :dca], @t);
   end
   
   #true if the user is in a tournament right now
   def in_tournament?(user)
      if user.nil? #if not signed in
         return false; #no user to be attending
      end
      
      #get array of tournaments
      tournament_list = TournamentAttendee.where(user_id: user[:id]).to_a;
      
      #get most current if exists
      current = false; #assume no current tournament
      tournament_list.each { |t| #check each tournament
         if t.start_time <= DateTime.now <= t.end_time #if currently attneding one
            current = true;
         end
      }
      
      return current;
   end
   
end
