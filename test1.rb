# test1.rb
# Test algorithm of room allocation.
# It is nice and simple to test this on the `rails console`.
# 
# by Julian Borrey
# Created: 24/08/2013
# Last Edited: 28/08/2013

### Assumptions ###
# number of teams is a multiple of 4

class Model
   def run_model #one function to run them all
      #set up
      t = Tournament.new();
      t.set_teams();
      #t.show_teams();
      
      #assign scores
      t.shuffle_teams();
      t.sort_teams();
      #t.show_teams(); #verify that they are sorted
      
      #now make rooms
      t.allocate_rooms();
   end
end

class Tournament
   @@NUM_TEAMS_BP_ROUND; #this is a magic, move it after testing
   
   def initialize
      #hold all teams here
      @teams = [];
      @@NUM_TEAMS_BP_ROUND = 4;
   end
   
   def set_teams
      i = 0;
      while(i < 12)               #make many teams
         t = Team.new()           #make team object
         t.set_name("Team #{i}"); #set name
         t.score = (20 - i);
         @teams.push(t);          #add to list
         i = i + 1;
      end
   end
   
   #just prints out the teams
   def show_teams
      puts(@teams.to_s);
   end

   #assigns each room
   def allocate_rooms
      #assign rooms until all teams assigned
      while(!@teams.empty?) #assumes multiple of 4 num elts
         assign_top_bracket(); #assign the top brack rooms
      end
   end
   
   #assign the top bracket of teams in the list
   #this function will remove them once allocated
   def assign_top_bracket
      #get score for this bracket
      top_score = @teams[0].score;
      
      #start the list for this bracket
      bracket = [];
      bracket.push(@teams[0]);
           
      #check upto what index can be in this bracket
      i = 0;
      while((@teams.empty?) and @teams[i].score >= top_score)
         i = i + 1;
      end
      #at this point, i should represent the number of teams
      #that should be added to the bracket
      #total number in bracket is (i+1) to account for top team

      #choose whether we must pull someone up or not
      excess = (i+1) % @@NUM_TEAMS_BP_ROUND;
      if(excess != 0) #if we don't have whole BP rooms
         #increase index to a multiple of 4
         i = i + (@@NUM_TEAMS_BP_ROUND - excess);
      end
      #at this point i represents the last team 
      #in this bracket (array starts at 0)
      
      #assign these teams to their rooms
      puts("we have #{@teams.count} teams left");
      assign_teams_in_bracket(i+1);
   end
   
   #function to deal with the whole bracket
   #calls room assignement function until all teams done in this bracket
   def assign_teams_in_bracket(num_teams)
      teams_left = num_teams; #we start with all teams in bracket left
      
      while(teams_left > 0) #while teams left to allocate
         assign_room_for_bracket(teams_left); #do a room assignment
         teams_left = teams_left - @@NUM_TEAMS_BP_ROUND; #lost n teams to room
      end

   end
   
   #function to assign a single room based on bracket
   #argument is number of teams in the bracket to choose from
   #since sorted we know to use the teams from 
   #@teams[0] to @teams[num_teams - 1]
   def assign_room_for_bracket(num_teams)
      #for now, we randomly assign teams within the bracket
      r = Round.new();
      cards_in_hat = [1,2,3,4]; #set up the hat

      i = 0;
      while(i < @@NUM_TEAMS_BP_ROUND)
         ### select team from bracket
         #take into account boundary index and num teams left to allocate
         chosen_team = @teams[rand(num_teams-i)];
         @teams.delete(chosen_team); #remove team since taken for round
         
         ### select position
         position = cards_in_hat.sample(); #get a random element
         cards_in_hat.delete(position);    #remove the card form the hat
         
         ### input into round
         r.input_team(chosen_team, position);
         i = i + 1;
      end

      r.show();
   end

   #method to sort by team points and speaks
   def sort_teams
      @teams.sort! { |a,b| b.calc_rank <=> a.calc_rank }
      
      #@teams.sort! { |a,b| b.score <=> a.score } #allows sorting by score only
      #expression is flipped in terms of a and b
      #therefore we have decending in teams by score
   end

   def shuffle_teams
      @teams[0].score  = 0
      @teams[0].speaks = 800;
      
      @teams[1].score  = 1
      @teams[1].speaks = 1800;
      
      @teams[2].score  = 2
      @teams[2].speaks = 900;
      
      @teams[3].score  = 0
      @teams[3].speaks = 4300;
      
      @teams[4].score  = 1
      @teams[4].speaks = 234;
      
      @teams[5].score  = 2
      @teams[5].speaks = 493;
      
      @teams[6].score  = 0
      @teams[6].speaks = 948;
      
      @teams[7].score  = 1
      @teams[7].speaks = 232;
      
      @teams[8].score  = 2
      @teams[8].speaks = 22;
      
      @teams[9].score  = 0
      @teams[9].speaks = 948;
      
      @teams[10].score = 1
      @teams[10].speaks = 123;
      
      @teams[11].score = 2
      @teams[11].speaks = 9000;
   end
   
end

class Team
   @name;   #team name (string)
   @score;  #team score (int)
   @speaks; #cumulative speaker score for team (int)

   attr_accessor(:score); #allows access to the private variable
   attr_accessor(:speaks);
   attr_accessor(:name);
   
   #intialize object - run after new automatically
   def initialize
      @score  = 0;
      @speaks = 0;
      @name   = "";
   end
   
   #accessing this attribute the old school way
   #set the name of the team
   def set_name(name_in)
      @name = name_in.clone();
   end
   
   #method to get rank based on team score and speaks
   #the solution is to use a weighted system where the 
   #speaks are treated with a value of 1 and the a single
   #point for score is at minimum larger than the maximum 
   #number of speaker points for the tournament
   #
   #the worlds tournament has 9 rounds with a max speaker 
   #rating of 100 per speaker. This means that 2*100*9 = 
   #1800 is the max. In the case that a tournament was to 
   #go for 100 rounds (which is rediculous) we could imagine 
   #the max speaks being 20,000. This will be our threshold.
   def calc_rank
      return (self.score * 20000) + self.speaks;
      end
end

#class to save an entire round (could correspond to db)
class Round
   #each position
   @OG;
   @OO;
   @CG;
   @CO;
   
   #function to allocate 'team' to 'position'
   def input_team(team, position)
      if   (position == 1)
         @OG = team;
      elsif(position == 2)
         @OO = team;
      elsif(position == 3)
         @CG = team;
      elsif(position == 4)
         @CO = team;
      end
   end
   
   def show
      puts("Round has OG: #{@OG.name}, OO: #{@OO.name}, CG: #{@CG.name}, CO: #{@CO.name}");
   end
end
