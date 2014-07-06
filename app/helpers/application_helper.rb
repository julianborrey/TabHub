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
      rounds= []; #return value

      i = 0;
      potentials = Round.order(created_at: :desc).limit(100).to_a;
      potentials.shuffle!;
      #surely in 100 rounds we can find what we want
      ###can fix this later to true for larger --- expand this foo later
      
      #keep searching until length is 3
      while rounds.length < 3
         if true #eventuall --> potentials[i].tournament.settings.public?
            rounds.push(potentials[i]);
         end
         i = i + 1;
      end

      return rounds;
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
end
