module SessionsHelper
   
   #one token for cookies, then the encrypted one for the data base.
   def sign_in(user)
      remember_token = User.new_remember_token
      cookies.permanent[:remember_token] = remember_token
      user.update_attribute(:remember_token, User.encrypt(remember_token))
      self.current_user = user
   end

   #def signed_in?
	#	puts("in SINGED_IN?");
	#	puts("we currently have " + @current_user.to_s);
   #   !(current_user.nil?)
   #end

   def current_user=(user)
      @current_user = user
   end

   def current_user
      remember_token  = User.encrypt(cookies[:remember_token])
      @current_user ||= User.find_by(remember_token: remember_token)
      return @current_user;
   end

   def current_user?(user)
      user == current_user
   end
   
   ####SECURITY#######
   # Check that manipulating the cookie[:sesson][:return_to] attribute
   # will not allow entry into restricted area.

   def signed_in_user
         store_location
         redirect_to root_path, notice: "Please sign in." unless signed_in?
         #we are adding an option to the redirect_to function which is a hash
         #it updates the flash[] hash
   end

   def sign_out
      self.current_user = nil
      cookies.delete(:remember_token)
   end
   
   def redirect_back_or(default)
      redirect_to(session[:return_to] || default)
      clear_return_to
   end
   
   private

      def store_location
         session[:return_to] = request.url
         session[:return_to] ||= root_path; #in case this was a cold request
      end

      def clear_return_to
         session[:return_to] = nil
      end
      
end
