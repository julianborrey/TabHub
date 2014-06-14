class Institution < ActiveRecord::Base
   has_many(:users);
   has_many(:tournaments);

   validates(:short_name, presence: true);
   validates(:full_name, presence: true);
   
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
end
