class Motion < ActiveRecord::Base
   belongs_to(:round);
   belongs_to(:tournament);

   validates(:wording, presence: true);
   validates(:user_id, presence: true);
   #will not validate for tournment, becasue we want 
   #to be able to trade these entities online
   #same with round_id

   def self.get_year_range_for_select_tag
   	year_range = get_year_range(); #get all range of motion years
   	current = year_range[:end_year]
   	array = [];
   	
   	#get whole range of years
   	while current >= year_range[:start_year]
   		array.push([current.to_s, current]);
   		current = current - 1;
   	end

   	return array;
   end

   def self.get_tournaments_for_select_tag
		all_tournaments = [["all tournaments", 0]];
		Motion.all.each { |m| 
			all_tournaments.push({"name"          => m.tournament.name,
										 "tournament_id" => m.tournament.id });
		}

		#for testing on empty db
		if all_tournaments.empty? || all_tournaments.size == 1
			all_tournaments = [["all tournaments", 0], ["ABC",1], ["FGH",2]];
		end
		all_tournaments.uniq;
   end

   private
   	def self.get_year_range
   		all_motions_ascending = Motion.order(created_at: :asc);
   		if all_motions_ascending.empty?
   			return {start_year: 2014, end_year: 2014};
   		end

   		return {
   			start_year: all_motions_ascending.first.year, 
   		   end_year:   all_motions_ascending.last.year
			};
   	end

end
