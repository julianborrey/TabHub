class Institution < ActiveRecord::Base
   has_many(:users);
   has_many(:tournaments);
   has_many(:rooms);
   has_many(:conflicts);
   has_many(:allocations);
   
   validates(:short_name, presence: true);
   validates(:full_name, presence: true);
   validates_uniqueness_of(:short_name);
   validates_uniqueness_of(:full_name);
   
   #returns array of current members
   #ranked exec at the top
   def current_members_list
      #get all users
      users_array = self.users.to_a;

      #remove all the non-active
      users_array.reject! { |u| !u.active };

      #put president first
      users_array.each { |u|
         if u.president?
            users_array.delete(u);
            users_array.unshift(u);
         end
      }

      return users_array;
   end
   
   #returns array of alumni members
   #chronologically ordered
   def alumni_members_list
      #get all users
      users_array = self.users.to_a;
      
      #remove all active members
      users_array.reject! { |u| u.active };
      return users_array;
   end
   
   #returns all the teams from THIS institution at the GIVEN tournament
   def teams_at(tournament)
      #definitely want to come from tournament side
      list = tournament.teams.reject { |t| t.tournament_id != tournament.id }
      puts("list is: " + list.to_s);
      return list;
   end
   
end
