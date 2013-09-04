# user.rb
# 03/09/2013
# by Julian Borrey
# 
# The code to use the User model.

class User < ActiveRecord::Base
   ### Code to ensure that certain attributes constrainted ###
   #ensure that we are going to input an all lowercase email 
   #(helps with uniqueness check)
   before_save { email.downcase! } #new verions

   #we are going to set the user as only a viewer by default
   #before_create { self.status            = GlobalConstants::PRIVILEDGES[:viewer] }
   before_create(:create_remember_token)        #for session cookie
   
   #validates only with the presence of the name field
   #max length of name is 40 chars
   validates(:fname, presence: true, length: { maximum: 20 });
   validates(:lname, presence: true, length: { maximum: 20 });  
   
   #make a REGex
   VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i;
   validates(:email, presence: true, format: { with: VALID_EMAIL_REGEX },
                     uniqueness: { case_sensitive: false });
   #put uniqueness check on db as well to prevent double submit error
   
   ### CHECK THAT ^^^ ###
   
   has_secure_password #contains the validation against blank entries
   #also provides the fields password, confirmation on demand
   
   #password will be a minimum of 6 characters
   validates(:password, length: { minimum: 6 });
   
   ### Code to return a boolean value to check against privladges ##
   #def has_status?(status_to_check_for)
   #   #return the boolean value of correct status code
   #   return (self.status == GlobalConstants::PRIVILEDGES[status_to_check_for]);
   #end
   
   ### Function to return a string of the users priviledges
   #def priviledges_str
   #   raw_str = GlobalConstants::PRIVILEDGES_STR[self.status];
   #   return raw_str.capitalize(); #return with a the first capitalized letter 
   #end
   
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

      #def increment_nodes_strong_args
      #   update_hash = {num_nodes: (self.num_nodes + 1)}
      #   update_hash.require(:user).permit(:num_nodes);
      #   return update_hash;
      #end
end
