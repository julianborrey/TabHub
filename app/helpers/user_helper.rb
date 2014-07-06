module UserHelper
   #Using Gravatar means we need to get the profile picture via a 
   #URL which corresponds to the correct email address.
   #The hash which references the email address is formed by "hexdigest"
   
   def gravatar_for(user, options = { size: 50 })
      gravatar_id  = Digest::MD5::hexdigest(user.email.downcase)
      size = options[:size]; #retreive size from hash

      gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
      image_tag(gravatar_url, alt: user.name, class: "gravatar")
   end
   
   #function to make page title by user name
   def getUserName(id)
      u = User.find(id);
      if u.nil?
         render :status => 404;
      else
         str = u.full_name;
      end

      return str;
   end

end
