class Team < ActiveRecord::Base
   belongs_to(:tournament);
   belongs_to(:institution);
   belongs_to(:user);

   validates(:name, presence: true, length: {maximum: 50});
   validates(:institution_id, presence: true); #if = 0, open team
   validates(:tournament_id, presence: true);
   validates(:total_speaks, presence: true);
   validates(:points, presence: true);
   
   #could make this better by linking the databases probably
   ### returns an array of the members in the team
   def members
      m = []; #rtn value
      m.push(nil || User.find(self.member_1));
      m.push(nil || User.find(self.member_2));
      return m;
   end
end
