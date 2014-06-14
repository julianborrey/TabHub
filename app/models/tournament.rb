class Tournament < ActiveRecord::Base
   belongs_to(:user);        #host of the tournament online
   belongs_to(:institution); #uni host of the tournament

   has_many(:tournament_attendee); #table matching users to tournaments
   has_many(:team);
   has_many(:round);
   has_many(:motion);
   
   validates(:name, presence: true, length: {maximum: 100});
   validates(:institution_id, presence: true);
   validates(:location, presence: true);
   validates(:start_time, presence: true);
   validates(:end_time, presence: true);
   validates(:user_id, presence: true);

   #returns true if the user is authorized to edit this tournament
   def is_authorized?(user)
      return true; #for test
      #decided to start from user, not tournament, because a user probably 
      #has less entrees than a tournament ... should take less processing time
      user_list = user.tournament_attendees.to_a;
      
      #get entries for this tournament
      user_list_for_self = [];
      user_list.each { |ta|
         if ta.tournament_id == self.id
            user_list_for_self.push(ta);
         end
      }

      #now check if they have tab_room status or higher
      user_list_for_self.each { |ta|
         if (ta.role == GlobalConstants::TOURNAMENT_ROLES[:tab_room]) ||
            (ta.role == GlobalConstants::TOURNAMENT_ROLES[:ca]      ) ||
            (ta.role == GlobalConstants::TOURNAMENT_ROLES[:dcs]     )
            
            return true;
         end
      }
      
      #if we make it here, they are not in the tab room
      return false;     
   end
   
   #returns tournament's host insititution's short name
   def get_host_name
      return self.institution.short_name;
   end

   #returns a string of the number of rounds for this tournament
   def get_num_rounds
        #fill in when do rounds
        return "9";
   end
   
   #true if tournament is currently happening
   def live?
      return self.status == GlobalConstants::TOURNAMENT_STATUS[:present];
   end

   #returns hash of string-string pairs for color-status of the tournament'sstatus
   def get_status
      status = {}; #return val
      
      #we are find with "past"
      status = {"gray" => GlobalConstants::TOURNAMENT_STATUS_STR[self.status].capitalize};
      
      #but we want to use "Live!" for :current and "Coming up" for :future
      if self.status == GlobalConstants::TOURNAMENT_STATUS[:present]
         status = {"#33cc33" => "Live!"};
      elsif self.status == GlobalConstants::TOURNAMENT_STATUS[:future]
         status = {"blue" => "Coming Up"};
      end

      return status;
   end

   def get_current_round
      return "4";
   end
   
   #return current topic or "" if there is none
   def current_topic
      return "THW go ham.";
   end

   #return true is user is a debater at this tournament
   def debater_in?(user)
      #again, coming from the user side for faster processing
      user_list = User.tournament_attendees.to_a;
      user_list.each { |ta|
         if (ta.tournament_id == self.if) && (ta.user_id == user.id)
            return true;
         end
      }
      return false;
   end
   
   #returns array of numbers which corresponds to the number of points in each round
   def debater_stats(user)
      points_each_round = []; #return value
      
      #for testing
      points_each_round = [1, 3, 2, 3, 0, 2, 4, 1, 3, 1, 3,2,3,1,2,32,1,3,21];
      
      return points_each_round;
   end
end
