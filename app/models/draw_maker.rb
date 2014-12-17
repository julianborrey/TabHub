# DrawMaker.rb
# Test algorithm of room allocation.
# It is nice and simple to test this on the `rails console`.
# 
# by Julian Borrey
# Created: 24/08/2013
# Last Edited: 13/10/2014

module DrawMaker

	#TODO: 
		# Include the format arg in tournament
		# Make the logic to ensure teams get a good distribution of positions
		# Make logic for teams to get good distribution of rooms...tough!
		# better distribute adjs, not 2 best to next room, pop + pop(q + 1)
		# take into account the conflicts

	class DrawMakerClass
		@num_rooms_assigned; #start off with a progress of 0

		#the method which makes the draw
		#the only public method
		def make_draw(round, format)
			@num_rooms_assigned = 0;
			round.tournament.update(progress: 0.0); #reset progress to 0
	      allocate_rooms(sort_teams_and_adjs(round), round, format); #make rooms
		end

		private #all private methods

			#method to sort by team points and speaks
			#sorts in ascending order
		   def sort_teams_and_adjs(round)
		   	teams = round.tournament.teams;
		      teams.sort! { |a,b| a.points <=> b.points }

		      adjs = round.tournament.adjs
		      adjs.sort!  { |a,b| a.rating <=> b.rating }

		      return [teams, adjs]
		   end

	   	#assign rooms until all teams assigned
		   def allocate_rooms(sorted_teams_and_adjs, round, format)
		   	sorted_teams = sorted_teams_and_adjs[0].to_a;
		      sorted_wings = sorted_teams_and_adjs[1].to_a;
		      
		      #seperate the chair judges
		      num_rooms = sorted_teams.count / GlobalConstants::FORMAT[format][:num_teams_per_room];
		      sorted_chairs = sorted_wings.pop(num_rooms);

		      #shuffle adjs?

		      #get list of rooms that are left
		      rooms = round.tournament.rooms.shuffle;

		      while(!sorted_teams.empty?) #assumes multiple of 4 num elts
		         assign_top_bracket(num_rooms, sorted_teams, sorted_chairs, sorted_wings, rooms, round, format); #assign the top brack rooms
		      end
		   end
		   
		   #assign the top bracket of teams in the list
		   #this function will remove them from the list once allocated
		   def assign_top_bracket(num_rooms, sorted_teams, sorted_chairs, sorted_wings, rooms, round, format)
		      #get score for this bracket
		      top_score = sorted_teams[0][:points];
		           
		      #check upto what index can be in this bracket
		      i = 1; #one team currently in the bracket
		      while((i < sorted_teams.count) && (sorted_teams[i].points >= top_score))
		         i = i + 1;
		      end
		      #at this point, i should represent the number of teams
		      #that should be in this bracket

		      #choose whether we must pull someone up or not
		      excess = i % GlobalConstants::FORMAT[format][:num_teams_per_room];
		      if(excess != 0) #if we don't have whole BP rooms
		         num_teams_to_add = GlobalConstants::FORMAT[format][:num_teams_per_room] - excess;
		         i = i + num_teams_to_add;
		      end
		      #at this point i represents the last team 
		      
		      #assign these teams to their rooms
		      assign_teams_in_bracket(num_rooms, sorted_teams.pop(i), sorted_chairs, sorted_wings, rooms, round, format);
		   end
		   
		   #function to deal with the whole bracket
		   #calls room assignement function until all teams done in this bracket
		   def assign_teams_in_bracket(num_rooms, teams, sorted_chairs, sorted_wings, rooms, round, format)
		      teams_left = teams.count; #we start with all teams in bracket left
		      teams.shuffle(); #important to shuffle the bracket

		      #THIS IS WHERE WE NEED LOGIC TO PLACE GROUPS OF TEAMS WHICH HAVE COMPLIMENTARY POSITION PREFERENCES

		      while(teams_left > 0) #while teams left to allocate
		         assign_room_for_bracket(num_rooms, 
		         								teams.pop(GlobalConstants::FORMAT[format][:num_teams_per_room]), 
		         								sorted_chairs, sorted_wings, rooms, round, format); #do a room assignment
		         teams_left = teams_left - GlobalConstants::FORMAT[format][:num_teams_per_room]; #lost n teams to room
		      end
		   end
		   
		   #function to assign a single room based on bracket based on given teams
		   def assign_room_for_bracket(num_rooms, teams, sorted_chairs, sorted_wings, rooms, round, format)
		   	#select a room at random for this room
		   	room = rooms.pop(); #they have already been shuffled

		      #for now, we randomly assign teams within the bracket
		      rd = RoomDraw.new(tournament_id: round.tournament[:id], round_id: round[:id], 
		      					  room_id: room, #it is already an id 
		      					  status: GlobalConstants::ROOM_DRAW_STATUS[:not_finished]);

		      i = 0;
		      while(i < GlobalConstants::FORMAT[format][:num_teams_per_room])
		         #select team at random from the remaining amount
		         chosen_team = teams.pop(); #the bracket was already shuffled
		         #we can just pick them out in order

		         #ensure this team has not been this position too many times
		         #the position is i (0 for OG, 1 for OO, etc.)
		         #SOME LOGIC

		         #if good selection, remove from the hat
		         teams.delete(chosen_team); #remove team since taken for round
		         	         
		         #input team into room draw
		         input_team(rd, chosen_team, i, format);
		         
		         i = i + 1; #increment to know we have allocated a team
		      end

		      #try to save this room since we have all the info
		      if !rd.save();
		      	throw("Could not save RoomDraw.");
		      end
		      
		      #throw in the adjs based simply on rank and top room
		      input_adjs(rd, sorted_chairs, sorted_wings, 
		      			  calculate_num_adjs(num_rooms, sorted_chairs.count, sorted_wings.count));

	      	
	      	@num_rooms_assigned = @num_rooms_assigned + 1;
	      	round.tournament.update(progress: ((@num_rooms_assigned / num_rooms.to_f) * 100));
		   end

		   #method to input a team into the round at numerical position given
		   def input_team(room_draw, team, position, format)
		   	if format == :bp
			   	if position == 0
			   		room_draw[:og_id] = team[:id];
			   	elsif position == 1
			   		room_draw[:oo_id] = team[:id];
			   	elsif position == 2
			   		room_draw[:cg_id] = team[:id];
			   	else
			   		room_draw[:co_id] = team[:id];
			   	end
			   end
		   end

		   #method to input num_adjs into the rooms draw with min 1 chair
		   def input_adjs(room_draw, sorted_chairs, sorted_wings, num_adjs)
		   	#first thing, add the chair
		   	if !input_single_adj(room_draw, sorted_chairs.pop(), true);
		   		throw("Could not save chair adj assignment.");
		   	end

		   	num_adjs_added = 1; #added the chair so far

		   	#now add the remainder
		   	while(num_adjs_added < num_adjs)
		   		if !input_single_adj(room_draw, sorted_wings.pop(), false);
		   			throw("Could no save wing adj assignment.");
		   		end
		   		num_adjs_added = num_adjs_added + 1;
		   	end
		   	return;
		   end

		   #method to input one adj into the this room draw
		   #by "input" we mean make a table entry
		   def input_single_adj(room_draw, adj, chair)
		   	return AdjAssignment.new(tournament_id: room_draw.tournament[:id], 
		   		 					round_id:      room_draw.round[:id], 
		   		 					room_draw_id:  room_draw[:id], 
		   		 					user_id:       adj[:user_id],
		   		 					chair:         chair).save;
		   end

		   #if this slows us down too much, we should make an array at the start
		   def calculate_num_adjs(num_rooms, num_chairs, num_wings)
		   	#residue is how many higher rooms will have an "extra"
		   	residue = num_wings % num_rooms;

		   	#q is how many each room should have minimum
		   	#the 1 represents the chair
		   	#num_wings / num_rooms is how wing allocations per room we can definitely do
		   	q = 1 + num_wings / num_rooms; #this will naturally floor()

		   	extra = 0; #assume no extra
		   	#if in upper lot of rooms, assign 1 extra wing
		   	if (residue != 0) && (@num_rooms_assigned <= residue)
		   		extra = 1;
		   	end
		   	
		   	return (q + extra);
		   end
	end

end