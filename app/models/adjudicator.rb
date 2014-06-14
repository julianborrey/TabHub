class Adjudicator < ActiveRecord::Base
   belongs_to(:round);

   validates(:user_id, presence: true);
   validates(:round_id, presence: true);
   validates(:adjudicator, presence: true);
end
