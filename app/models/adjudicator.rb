class Adjudicator < ActiveRecord::Base
   belongs_to(:room_draw);
   belongs_to(:tournament);
   belongs_to(:user);
   
   validates(:user_id, presence: true);
   validates(:room_draw_id, presence: true);
   validates(:adjudicator, presence: true);
   validates(:chair, presence: true);
   validates(:tournament_id, presence: true);
end
