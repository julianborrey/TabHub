#the object of the person for the pusposes of the tournament

class TournamentAttendee < ActiveRecord::Base
   belongs_to(:users);
   belongs_to(:tournaments);
end
