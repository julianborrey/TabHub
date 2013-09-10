class TournamentAttendee < ActiveRecord::Base
   belongs_to(:users);
   belongs_to(:tournaments);
end
