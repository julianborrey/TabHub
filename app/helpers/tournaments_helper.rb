module TournamentsHelper

   def get_user_tourns(user)
      if user.nil? #if not signed in
         return nil; #no user to be attending
      end
      
      #get array of tournaments
      attendee_entrees = TournamentAttendee.where(user_id: user[:id]).to_a;
      tournament_list = [];
      attendee_entrees.each { |e|
         tournament_list.push(Tournament.find(e.tournament_id));
      }

      user_list = {past: [], current: [], upcoming: []};

      #get most current if exists
      tournament_list.each { |t| #check each tournament
         if t.status == GlobalConstants::TOURNAMENT_STATUS[:past] #if in the past
            user_list[:past].push(t);
         end
         
         if t.status == GlobalConstants::TOURNAMENT_STATUS[:present] #if currently attneding one
            user_list[:current].push(t);
         end
         
         if t.status == GlobalConstants::TOURNAMENT_STATUS[:future] #if coming up
            user_list[:upcoming].push(t);
         end
      }
      
      return user_list;
   end

end
