class Tournament < ActiveRecord::Base
   belongs_to(:user);        #host of the tournament online
   belongs_to(:institution); #uni host of the tournament

   has_many(:tournament_attendee); #table matching users to tournaments
   has_many(:team);
   
   validates(:name, presence: true, length: {maximum: 100});
   validates(:institution_id, presence: true);
   validates(:location, presence: true);
   validates(:start_time, presence: true);
   validates(:end_time, presence: true);
   validates(:user_id, presence: true);
end
