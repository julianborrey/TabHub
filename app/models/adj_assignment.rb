class AdjAssignment < ActiveRecord::Base
	belongs_to(:user);
   belongs_to(:tournament);
   belongs_to(:round);
   belongs_to(:room_draw);
   
   has_one(:user);
   has_one(:tournament);
   has_one(:round);
   has_one(:room_draw);
   
   validates(:user_id, presence: true);
   validates(:tournament_id, presence: true);
   validates(:round_id, presence: true);
   validates(:room_draw_id, presence: true);
   validates(:chair, :inclusion => {:in => [true, false]});
   
   #this is a tricky one!
   #validates(:chair, uniqueness: {scope: room_draw});
end
