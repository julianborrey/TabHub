class Team < ActiveRecord::Base
   belongs_to(:tournament);
   belongs_to(:institution);
   
   belongs_to(:member_1, class_name: 'User');
   belongs_to(:member_2, class_name: 'User');
   
   has_many(:og, class_name: 'RoomDraw', foreign_key: 'og');
   has_many(:oo, class_name: 'RoomDraw', foreign_key: 'oo');
   has_many(:cg, class_name: 'RoomDraw', foreign_key: 'cg');
   has_many(:co, class_name: 'RoomDraw', foreign_key: 'co');
   
   #getting all roomDraw for this team
   ##(it would include all tournaments)
   def room_draws
      return og + oo + cg + co;
   end
   
   #make this function to get both members in one
   def users
      return [member_1, member_2];
   end

   def users_ids
      return [member_1_id, member_2_id];
   end
   
   validates(:name, presence: true, length: {maximum: 50},
                    uniqueness: {scope: :tournament_id, case_sensitive: false});
   #decided to be !caseSensitive on names, lowers possible confusion
   
   validates(:institution_id, presence: true); #if = 0, open team
   validates(:tournament_id, presence: true);
   validates(:total_speaks, presence: true);
   validates(:points, presence: true);
   
   #returns true for the team being in an active tournament
   def current?
      return self.tournament.live?
   end
   
   #returns the team's rank at the teams tournament
   def rank_by_only_points
      list = self.tournament.get_ranked_list_from_only_points.to_a;
      #return (list.index(self) + 1);
      #this was a nice idea, but it doesn't work because of ties
      
      i = 0;
      current_rank = 1;
      previous_points = -1;
      number_tied_teams = 0;
      while list[0] != self #go through list until we find us
         #if points of team before was the same, no rank increase
         #but we count the number of teams on same points
         #then add them all at once to the rank
         if (previous_points > list[0].points) || (previous_points == -1)
            current_rank = current_rank + number_tied_teams + 1;
            previous_points = list[0].points;
            number_tied_teams = 0;
         else #in this case we had teams on same num points
            number_tied_teams = number_tied_teams + 1;
         end
         i = i + 1;
      end

      return current_rank;
   end
end
