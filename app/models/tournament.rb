class Tournament < ActiveRecord::Base
   belongs_to(:user);        #host of the tournament online
   belongs_to(:institution); #uni host of the tournament

   has_many(:tournament_attendees); #table matching users to tournaments
end
