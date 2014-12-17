# application_helper.rb
# Created:      30/08/2013
# Last Updated: 30/08/2013
# by Julian Borrey
# 
# Helper functions for the application in general.

module ApplicationHelper
   #helper function to return the title of a page
   #returns a base title unless more is specified
   def full_title(page_title)
      base_title = "TabHub";
      
      #we have made a base title, now chose the return value
      if(page_title.empty? or (page_title == "Home")) #if no page specified
         return base_title; #we return the base title
      else #otherwisew we return the rendered string below
         return "#{base_title} | #{page_title}"
      end
   end

   #give 3 random but recent rounds - must have been launched and public
   def recent_rounds
      rounds = []; #return value
      rounds = Round.order(created_at: :desc).limit(30).to_a;

      #better make sure this thing is public...
      rounds.reject { |r| r[:status] != GlobalConstants::ROUND_STATUS[:round_started] }
      rounds.shuffle!;
      return rounds[0..2];
   end
   
   #function to put all object errors into the message object
   def load_errors(obj)
         obj.errors.full_messages.each { |m|
            @msg.add(:error, m);
         }
   end
   
   #returns a nicely rendered role (for ca, dca or tabbie)
   def nice_role(role_id)
      if role_id != GlobalConstants::TOURNAMENT_ROLES[:tab_room]
         return GlobalConstants::TOURNAMENT_ROLES_STR[role_id].to_s.upcase;
      else
         return GlobalConstants::TOURNAMENT_ROLES_STR[role_id].to_s.titleize;
      end
      return nil;
   end

   def redirect_if_not_signed_in
   	redirect_to root_path unless user_signed_in?
   end

   def devise_mapping
	  Devise.mappings[:user]
	end

	def resource_name
	  devise_mapping.name
	end

	def resource_class
	  devise_mapping.to
	end

	def resource
    @resource ||= User.new
   end

   def get_confirmed_user(u_id)
   	possible_u = User.find(u_id);
   	if possible_u != nil #if found something
   		if possible_u.confirmation_token == nil #mean they are confirmed
   			return possible_u;
   		end
   	end
   	return nil;
   end

   def illegal_access_path(page)
      return root_path + 'errors/illegal-access/' + page.to_s;
   end

end