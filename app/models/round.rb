class Round < ActiveRecord::Base
   belongs_to(:tournament);
   
   has_one(:motion);
   accepts_nested_attributes_for(:motion);
   
   validates(:tournament_id, presence: true);
   validates(:round_num, presence: true);
   validates(:status, presence: true);
   
   #returns the start time of the round (start of prep)
   def start_time
      return "1530";
   end

   #returns amount of time passed in prep
   #will end at 15:00
   def prep_time_passed
      return "7:34"
   end

   #returns time of prep time end
   def prep_time_end
      return "1545";
   end
   
   #returns the round number of this round
   def get_rank
      list = self.tournament.rounds.to_a;
      #this list will be chronological already

      i = 0;
      while list[i].id != self.id
         i = i + 1;
      end
      return (i + 1);
   end
end
