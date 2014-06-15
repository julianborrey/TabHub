module TournamentsHelper

   def get_user_tourns(user)
      if user.nil? #if not signed in
         return nil; #no user to be attending
      end
      
      #get array of tournaments
      tournament_list = [];
      user.tournament_attendees.each { |e|
         tournament_list.push(Tournament.find(e.tournament_id));
      }

      user_list = {past: [], present: [], future: []};

      #get most current if exists
      tournament_list.each { |t| #check each tournament
         if t.status == GlobalConstants::TOURNAMENT_STATUS[:past] #if in the past
            user_list[:past].push(t);
         end
         
         if t.status == GlobalConstants::TOURNAMENT_STATUS[:present] #if currently attneding one
            user_list[:present].push(t);
         end
         
         if t.status == GlobalConstants::TOURNAMENT_STATUS[:future] #if coming up
            user_list[:future].push(t);
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
