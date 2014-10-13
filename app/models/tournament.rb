class Tournament < ActiveRecord::Base
   serialize :rooms, Array #we have an array of room_ids

   belongs_to(:user);        #host of the tournament online
   belongs_to(:institution); #uni host of the tournament
   
   has_many(:tournament_attendees); #table matching users to tournaments
   has_many(:teams);
   has_many(:rounds);
   has_many(:motions);
   has_many(:allocations);
   has_many(:room_draws);
   
   has_one(:tournament_setting);
   accepts_nested_attributes_for(:tournament_setting);

   validates(:name, presence: true, length: {maximum: 100});
   validates(:name, uniqueness: true); 
   validates(:institution_id, presence: true);
   validates(:location, presence: true);
   validates(:start_time, presence: true);
   validates(:end_time, presence: true);
   validates(:user_id, presence: true);

   #returns true if the user is authorized to edit this tournament
   def is_authorized?(user)
      return true; #for test
      #decided to start from user, not tournament, because a user probably 
      #has less entrees than a tournament ... should take less processing time
      user_list = user.tournament_attendees.to_a;
      
      #get entries for this tournament
      user_list_for_self = [];
      user_list.each { |ta|
         if ta.tournament_id == self.id
            user_list_for_self.push(ta);
         end
      }

      #now check if they have tab_room status or higher
      user_list_for_self.each { |ta|
         if (ta.role == GlobalConstants::TOURNAMENT_ROLES[:tab_room]) ||
            (ta.role == GlobalConstants::TOURNAMENT_ROLES[:ca]      ) ||
            (ta.role == GlobalConstants::TOURNAMENT_ROLES[:dcs]     )
            
            return true;
         end
      }
      
      #if we make it here, they are not in the tab room
      return false;     
   end
   
   #returns tournament's host insititution's short name
   def get_host_name
      return self.institution.short_name;
   end

   #returns a string of the number of rounds for this tournament
   def get_num_rounds
        #fill in when do rounds
        return self.rounds.count;
   end

   #returns number of rounds complete so far
   def num_rounds_complete
      return self.round_counter;
   end
   
   #true if tournament is currently happening
   #def live?
   #   return self.status == GlobalConstants::TOURNAMENT_STATUS[:present];
   #end
   ### depricated with the deprication of status col in Tournament
   
   #true if tournament is currently happening
   def live?
      if self.status == GlobalConstants::TOURNAMENT_STATUS[:present]
         return true;
      end
      return false;
   end
   
   #returns hash of string-string pairs for color-status of the tournament'sstatus
   def get_status
      status = {}; #return val
      
      #we are find with "past"
      status = {"gray" => GlobalConstants::TOURNAMENT_STATUS_STR[self.status].capitalize};
      
      #but we want to use "Live!" for :current and "Coming up" for :future
      if self.live?
         status = {"#33cc33" => "Live!"};
      elsif self.status == GlobalConstants::TOURNAMENT_STATUS[:future]
         status = {"blue" => "Coming Up"};
      end

      return status;
   end
   
   #returns the round number string
   def get_current_round_num_str
   	#if counter is -1 or 0
   	if self[:round_counter] <= GlobalConstants::TOURNAMENT_PHASE[:open_rego]
   		return "N/A"
   	else
   		return self[:round_counter].to_s;
   	end
   end

   def current_round #can we not use some sort of select() ?
      r = self.rounds.reject { |i| i.round_num != self.round_counter }.first
	   return r;
   end
   
   def next_round
      r = self.rounds.reject { |i| i.round_num != (self.round_counter + 1) }.first
      return r;
   end

   #returns true if the tournament has a next round
   def has_next_round?
   	return (self[:round_counter] < self.rounds.count);
   end

   #returns true if the next round draw is made or is being made
   def made_or_making_next_draw?
   	return (progress > 0);
   end

   #returns true if the next round draw has been made
   def next_round_draw_made?
   	return (self.progress == 100);
   end
   
   #return current topic or "" if there is none
   def current_topic
      return "THW go ham.";
   end
   
   def enough_rooms
      return [false, "red", "No"];
   end
   
   def multiple4Check
      return [true, "#33cc33", "Yes"];
   end
   
   def enoughAdj
      return [true, "#33cc33", "Yes"];
   end
   
   def ballotCheck
      return [false, "red", "No"];
   end

   def hasRounds?
   	return  (self.rounds != nil) && (self.rounds.count > 0)
   end

   #return true is user is a debater at this tournament
   def debater_in?(user)
      #again, coming from the user side for faster processing
      user_list = User.tournament_attendees.to_a;
      user_list.each { |ta|
         if (ta.tournament_id == self.if) && (ta.user_id == user.id)
            return true;
         end
      }
      return false;
   end

   ### lets make this array one day
   #returns the team of user in this tournament
   def team_of(user)
      user.teams.each { |t|
         if t.tournament_id == self.id
         return t.name;
         end
      }
      return nil;
   end
   
   #returns array of numbers which corresponds to the number of points in each round
   def debater_stats(user)
      points_each_round = []; #return value
      
      #for testing
      points_each_round = [1, 3, 2, 3, 0, 2, 4, 1, 3, 1, 3,2,3,1,2,32,1,3,21];
      
      return points_each_round;
   end
   
   #returns array of issues with starting the tournament now
   #they must have closed rego - for the non-manual tournaments that is
   #manual tournament will already have closed rego status
   def check_for_start
      return [];
   end

   #returns array of issues with ending the tournament now
   def check_for_end
      return [];
   end

   #returns array of issues with going to the next round
   def check_for_next_round
      return [];
   end

   #returns number of attendees
   def count_people
      #need to watch out for poeple with duplicate roles
      attendees = self.tournament_attendees.to_a;
      attendees.uniq! { |a| a.user_id };
      return attendees.count;
   end

   #return number of teams
   def count_teams
      return self.teams.count;
   end

   #returns the number of rooms needed for the next round
   def num_rooms_next_round
   	if self.hasRounds?
   		return 1; #self.next_round.room_draws.count;
   	else
   		return 0;
   	end
   end

   #gives ranked list of teams
   def get_ranked_list_from_only_points
      return self.teams.sort { |x,y| y.points <=> x.points };
   end
   
   def tabbies
      return TournamentAttendee.where(tournament_id: self.id, role: GlobalConstants::TOURNAMENT_ROLES[:tab_room]);
   end
   
   def adjs
      return TournamentAttendee.where(tournament_id: self.id, role: GlobalConstants::TOURNAMENT_ROLES[:adjudicator]);
   end
   
   #returns a list of all the institions that are coming (returns objects)
   #to make this faster, we could go all the way to implementing another table
   def institutions
      insts = [];
      self.tournament_attendees.each { |ta|
         insts.push(ta.user.institution);    
      }
      return insts.uniq; #remove duplicates
   end

   #returns a list of teams sorted by alphabetical institution
   def get_sorted_teams
      return self.teams.to_a.sort { |x,y| x.institution.full_name.downcase <=>  y.institution.full_name.downcase };
   end

   #returns list of teams in this tournament given an institution
   def get_teams_from_institution(inst)
      return self.teams.where(institution_id: inst[:id]).to_a;
   end

   #returns list of adjs in this tournament given an institution
   def get_adjs_from_institution(inst)
      tas = self.tournament_attendees.where(institution_id: inst[:id], 
                                            role: GlobalConstants::TOURNAMENT_ROLES[:adjudicator]);
      adj_list = [];
      tas.each { |ta|
         adj_list.push(ta.user);
      }

      return adj_list;
   end

   #returns true if team cap is reached in this tournament for given institution
   def has_maxed_out_teams(inst)
      return (get_teams_from_institution(inst).count >= 
             self.allocations.where(institution_id: inst[:id]).first.num_teams);
   end

   #returns true if adj cap is reached in this tournament for given institution
   def has_maxed_out_teams(inst)
      return (get_adjs_from_institution(inst).count >= 
             self.allocations.where(institution_id: inst[:id]).first.num_adjs);
   end
end
