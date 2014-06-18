class Conflict < ActiveRecord::Base
   belongs_to(:user);
   belongs_to(:institution);
   
   validates(:user_id, presence: true);
   validates(:institution_id, presence: true);

end
