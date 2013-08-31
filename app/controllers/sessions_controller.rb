class SessionsController < ApplicationController
   include SessionsHelper

   def new
   end
   
   def create #triggered upon signing
      #retrieve the user by email
      user = User.find_by(email: params[:session][:email].downcase)
      
      #if we are able to retrieve user based on email and password fits
      if user && user.authenticate(params[:session][:password])
         #sign user in and redirect to the user show page
         sign_in user
         redirect_back_or user
      else 
         #create an error message and re-render the signin form
         flash.now[:error] = 'Invalid email/password combination'
         render 'new'
      end
   end
   
   def destroy
      sign_out
      redirect_to root_url
   end
   
end
