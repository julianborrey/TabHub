#the object of the person for the pusposes of the tournament

class TournamentAttendee < ActiveRecord::Base
   belongs_to(:user); #seems to not work?
   belongs_to(:tournament);

   # returns string for display of the role for this entry
   def get_role
      str = ""; #return value
      str = GlobalConstants::TOURNAMENT_ROLES_STR[self.role].to_s.humanize.capitalize;
      return str;
   end
end
