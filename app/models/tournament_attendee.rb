#the object of the person for the pusposes of the tournament

class TournamentAttendee < ActiveRecord::Base
   belongs_to(:users); #seems to not work?
   belongs_to(:tournaments);

   # returns string for display of the role for this entry
   def get_role
      str = ""; #return value
      puts("self role  = " +self.role.to_s);
      str = GlobalConstants::TOURNAMENT_ROLES_STR[self.role].capitalize;

      return str;
   end
end
