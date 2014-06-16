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

end
