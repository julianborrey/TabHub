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
      base_title = "Super Tab";
      
      #we have made a base title, now chose the return value
      if(page_title.empty? or (page_title == "Home")) #if no page specified
         return base_title; #we return the base title
      else #otherwisew we return the rendered string below
         return "#{base_title} | #{page_title}"
      end
   end


end
