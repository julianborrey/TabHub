# test1.rb
# Test algorithm of room allocation.
# It is nice and simple to test this on the `rails console`.
# 
# by Julian Borrey
# Created: 24/08/2013
# Last Edited: 28/08/2013

class Model
   def run_model #one function to run them all
      #set up and sort
      t = Tournament.new();
      t.set_teams();
      t.show_teams();
      
      #assign realistic scores
      t.shuffle_teams();
      t.sort_teams();
      t.show_teams();
      
   end
end

class Tournament
   def initialize
      #hold all teams here
      @teams = [];
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
   
   def show_teams
      puts(@teams.to_s);
   end
   
   #method to sort by team points and speaks
   def sort_teams
      @teams.sort! { |a,b| b.calc_rank <=> a.calc_rank }
      
      #@teams.sort! { |a,b| b.score <=> a.score } #allows sorting by score only
      #expression is flipped in terms of a and b
      #therefore we have decending in teams by score
   end

   def shuffle_teams
      @teams[0].score = 0
      @teams[1].score = 1
      @teams[2].score = 2
      @teams[3].score = 0
      @teams[4].score = 1
      @teams[5].score = 2
      @teams[6].score = 0
      @teams[7].score = 1
      @teams[8].score = 2
      @teams[9].score = 0
      @teams[10].score = 1
      @teams[11].score = 2
   end
   
end

class Team
   @name;   #team name (string)
   @score;  #team score (int)
   @speaks; #cumulative speaker score for team (int)

   attr_accessor(:score); #allows access to the private variable
   attr_accessor(:speaks);
   
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
   def self.calc_rank
      return (self.score * 20000) + self.speaks;
   end
end
