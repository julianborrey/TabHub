# user.rb
# 03/09/2013
# by Julian Borrey
# 
# The code to use the User model.

class User < ActiveRecord::Base
   belongs_to(:institution);
   
   has_many(:team_1, class_name: 'Team', foreign_key: 'member_1_id');
   has_many(:team_2, class_name: 'Team', foreign_key: 'member_2_id');
   #getting all teams from user
   def teams
      return team_1 + team_2;
   end
   
   has_many(:conflicts);
   has_many(:tournaments);
   has_many(:tournament_attendees); #which tournaments the user attended

   ### Code to ensure that certain attributes constrainted ###
   #ensure that we are going to input an all lowercase email 
   #(helps with uniqueness check)
   before_save { email.downcase! } #new verions

   #we are going to set the user as only a general user by default
   before_create { self.status  = GlobalConstants::PRIVILEGES[:general] }
   before_create(:create_remember_token)        #for session cookie
   
   #validates only with the presence of the name field
   #max length of name is 40 chars
   validates(:fname, presence: true, length: { maximum: 20 });
   validates(:lname, presence: true, length: { maximum: 20 });  
   validates(:institution_id, presence: true); #we get this from a table
   ### ^^ could do a check to see that it is a valid id ################################

   #make a REGEX
   VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i;
   validates(:email, presence: true, format: { with: VALID_EMAIL_REGEX },
                     uniqueness: { case_sensitive: false });
   #put uniqueness check on db as well to prevent double submit error
   
   ### CHECK THAT ^^^ ###
   
   has_secure_password #contains the validation against blank entries
   #also provides the fields password, confirmation on demand
   
   #password will be a minimum of 6 characters
   validates(:password, length: { minimum: 6 });
  
   #validate they have selected a univeristy
   validates(:institution_id, numericality: {greater_than: 0});
   
   ### Code to return a boolean value to check against privladges ##
   def has_status?(status_to_check_for)
      #return the boolean value of correct status code
      return (self.status == GlobalConstants::PRIVILEGES[status_to_check_for]);
   end
   
   ### Function to return a string of the users priviledges
   def privileges_str
      raw_str = GlobalConstants::PRIVILEGES_STR[self.status];
      return raw_str.capitalize(); #return with a the first capitalized letter 
   end

   ### returns str which is the users role in given society. nil for not a part of the socity
   def society_role_str
      raw_str = GlobalConstants::SOCIETY_ROLES_STR[self.status];
      return raw_str.capitalize();
   end

   ### returns the full name of the user
   def full_name
      return self.fname + " " + self.lname;
   end

   ### true is pres
   def president?
      return self.status == GlobalConstants::SOCIETY_ROLES[:president];
   end
   
   ### true/false for user being president of given institution
   def president_of_institution?(inst)
      return (self.institution_id == inst.id && self.status == GlobalConstants::SOCIETY_ROLES[:president]);
   end
   
   #returns true if the user is an adjudicator in the given tournament
   def adj?(t)
      self.tournament_attendees.each { |ta|
         if ta.tournament_id == t.id && ta.role == GlobalConstants::TOURNAMENT_ROLES[:adjudicator]
            return true;
         end
      }
      return false; #made it here, no adj
   end

   #true if the user is in a tournament right now
   def in_tournament?
      return !self.get_tournaments(:present).empty?
   end
   
   def get_tournaments(status)
      list = self.tournament_attendees.to_a(); #record of user attedance
      
      current_tourns = [];
      list.each { |ta|
         if Tournament.exists?(ta.tournament_id)
            t = Tournament.find(ta.tournament_id);
            if !t.nil? && t.status == GlobalConstants::TOURNAMENT_STATUS[status]
               #if ### SHould have something here about someone leaving a tournament
               current_tourns.push(t);
               #end
            end
         end
      }
      
      #if we made it here, there was no active tournament
      return current_tourns;
   end
   #could for see a situation where someone is somehow in 2 tournaments
   #at the same time and isn't given access to the one they need.
   #have a page to view my current tournaments, button to be able to leave
      
   #true if the user is currently in a round
   def round_now?
      #something like the above, but also goes into finding the tournament and then cheking if any rounds are active.
      return false;
   end
   
   #returns true if THIS user is in the tab room of a tournament for the GIVEN user
   def in_tab_room_of?(u)
      tournaments_not_past = u.get_tournaments(:present) + u.get_tournaments(:future);

      tournaments_not_past.each { |t|
         if self.in_tab_room?(t)
            return true;
         end
      }
      return false;
   end
   
   #returns true is user in tabroom of tournament t
   def in_tab_room?(t)
      if t.is_a?(String)
         #therefore we assume its a tournament object
         t = t.to_i;
      elsif !t.is_a?(Fixnum)
         #assume it is the object
         t = t.id;
      end
      
      attendee_list = self.tournament_attendees.to_a;
      attendee_list.each { |e|
         if (e.tournament_id == t) && (e.role == GlobalConstants::TOURNAMENT_ROLES[:tab_room])
            return true;
         end
      }
      return false;
   end

   #returns the current Team of the user
   def current_team
      self.teams.each { |t|
         if t.current?
            return t;
         end
      }
      return nil;
   end
   
   def User.new_remember_token
      SecureRandom.urlsafe_base64
   end

   def User.encrypt(token)
      Digest::SHA1.hexdigest(token.to_s)
   end

   private
      def create_remember_token
         self.remember_token = User.encrypt(User.new_remember_token)
      end

end
