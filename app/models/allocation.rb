class Allocation < ActiveRecord::Base
   belongs_to(:tournament);
   belongs_to(:institution);

   validates(:tournament_id,  presence: true);
   validates(:institution_id, presence: true);
   validates(:num_teams,      presence: true);
   validates(:num_adjs,       presence: true);
end
