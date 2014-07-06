module InstitutionHelper
   #Using Gravatar means we need to get the profile picture via a 
   #URL which corresponds to the correct email address.
   #The hash which references the email address is formed by "hexdigest"
   
   def gravatar_for(user, options = { size: 50 })
      gravatar_id  = Digest::MD5::hexdigest(user.email.downcase)
      size = options[:size]; #retreive size from hash

      gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
      image_tag(gravatar_url, alt: user.name, class: "gravatar")
   end
   
   ### WE SHOULD MOVE THIS TO THE TOURNAMENT HELPER ###
   def round_now?
      return true;
   end

   #true if user can edit institution
   def authorized_user
      store_location
      u = current_user;
      redirect_to session[:return_to] unless !current_user.nil? && u.president_of_institution?(@institution);
   end
   
end
