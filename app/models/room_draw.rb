class RoomDraw < ActiveRecord::Base
   belongs_to(:tournament);
   belongs_to(:round);
   belongs_to(:room);
   
   belongs_to(:og, class_name: 'Team');
   belongs_to(:oo, class_name: 'Team');
   belongs_to(:cg, class_name: 'Team');
   belongs_to(:co, class_name: 'Team');
   belongs_to(:og, class_name: 'Team');
   belongs_to(:oo, class_name: 'Team');
   belongs_to(:cg, class_name: 'Team');
   belongs_to(:co, class_name: 'Team');
   
   #returns all the teams in this round
   def team_ids
      return [og_id, oo_id, cg_id, co_id];
   end
   
   #returns all team ids in this round
   def teams
      return [og, oo, cg, co];
   end
   
end
