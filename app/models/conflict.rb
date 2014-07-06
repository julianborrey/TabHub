class Conflict < ActiveRecord::Base
   belongs_to(:user);
   belongs_to(:institution);
   
   validates(:user_id, presence: true);
   validates(:institution_id, presence: true);
   validates(:institution_id, uniqueness: {scope: :user_id});
   
   #Note: when a user updates their institution (as in they move to another
   #university, we will add in the new conflict but not delete the old one.)

   #returns true if conflict from the user's current instition
   def from_current_institution?
      return self.insitution_id == self.user.institution_id;
   end
end
