#the object of the person for the pusposes of the tournament

class TournamentAttendee < ActiveRecord::Base
   belongs_to(:user); #seems to not work?
   belongs_to(:tournament);

   validates(:user_id,       presence: true);
   validates(:tournament_id, presence: true);
   validates(:role,          presence: true);

   validates_uniqueness_of(:user_id, scope: [:tournament_id, :role]);
   #still not proof, see APIdock. Says we should add_index.

   # returns string for display of the role for this entry
   def get_role
      str = ""; #return value
      str = GlobalConstants::TOURNAMENT_ROLES_STR[self.role].to_s.humanize.capitalize;
      return str;
   end
end
