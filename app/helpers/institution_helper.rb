module InstitutionHelper
   #Using Gravatar means we need to get the profile picture via a 
   #URL which corresponds to the correct email address.
   #The hash which references the email address is formed by "hexdigest"
   
   def gravatar_for(user, options = { size: 50 })
      gravatar_id  = Digest::MD5::hexdigest(user.email.downcase)
      size = options[:size]; #retreive size from hash

      gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
      image_tag(gravatar_url, alt: user.name, class: "gravatar")
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
   
   ##############T HTIS SHOULD NOT BE HERER!
   def get_user_tourn_ids(user)
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

   ### WE SHOULD MOVE THIS TO THE TOURNAMENT HELPER ###
   def round_now?
      return true;
   end

   #true if user can edit institution
   def authorized_user
      store_location
      u = current_user;
      redirect_to session[:return_to] unless !current_user.nil? && u.president_of_institution?(@institution);
   end
   
end
