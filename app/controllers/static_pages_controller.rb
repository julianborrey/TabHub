# static_pages_controller.rb
# Created:      30/08/2013
# Last Updated: 30/08/2013 
# by Julian Borrey
# 
# The controller to serve the static pages.

class StaticPagesController < ApplicationController
   include TournamentHelper

   def home
      @user = nil;
      @user ||= current_user;

      @tourn_list = nil;
      if !@user.nil?
         @tourn_list = get_user_attendence(@user);
      end
   end
   
   def about
   end
   
   def contact
   end
   
   def sponsors
   end

   def test
   end

   def pastmotions
      render "static_pages/past", :layout => false
   end
end
