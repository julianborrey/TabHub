class Motion < ActiveRecord::Base
   belongs_to(:round);
   belongs_to(:tournament);

   validates(:wording, presence: true);
   validates(:user_id, presence: true);
   #will not validate for tournment, becasue we want 
   #to be able to trade these entities online
   #same with round_id
end
