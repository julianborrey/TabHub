class Round < ActiveRecord::Base
   belongs_to(:tournament);
   has_many(:motion);
   has_many(:room);
   has_many(:adjudicator);
   
   validates(:tournament_id, presence: true);
   validates(:round_num, presence: true);
   validates(:status, presence: true);
   
end
