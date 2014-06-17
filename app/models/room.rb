class Room < ActiveRecord::Base
   belongs_to(:institution);

   validates(:name, presence: true, length: {maximum: 20});
   validates(:location, presence: true);
   validates(:institution_id, presence: true);
   validates(:place_id, presence: true);
end
