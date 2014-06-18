class InstitutionsController < ApplicationController
   before_action :authorised_user, only: [:edit, :update]

   def show
      #if the institution doesn't exist ... what happens?
      @institution = Institution.find(params[:id]);
      @user = current_user;
      @current_members = [];
      @alumni_members  = [];

      #if current user is from the viewed institution
      if !@user.nil? && @user.institution_id == @institution.id
         @current_members = @institution.current_members_list;
         @alumni_members  = @institution.alumni_members_list;
         #can do stats too
      
      else #the user is foreign to this instituion

         #maybe show the members list
         if @institution.show_members
            @current_members = @institution.current_members_list;
            @alumni_members  = @institution.alumni_members_list;
            #maybe stats one day
         end
      end
   end
   
   def new
      @institution = Institution.new();
   end
   
   def create
      @institution = Institution.new(institution_params) #user_params comes from private foo
      
      if @institution.save #if save successful (doesn't return false/nil)
         redirect_to(institution_path(@institution.id));
      else
         #redirect_to(signup_path, object: @user);
         render('institutions/new'); #render the new.html.erb template
      end
   end
   
   def edit
     @institution = Institution.find(params[:id])    

     redirect_to @institution unless !current_user.nil? && current_user.president_of_institution?(@institution)
   end
   
   def update
      @institution = Institution.find(params[:id]);

      #checking the institution exists and security
      redirect_to root_path unless !@institution.nil?
      redirect_to @institution unless !current_user.nil? && current_user.president_of_institution?(@institution)

      if @institution.update_attributes(institution_params)
         #handle a successful update
         flash[:success] = "Institution Updated"
         redirect_to @institution
      else
         render 'edit';
      end
   end


   private
      
      def institution_params #permit only said inputs
         params.require(:institution).permit(:full_name, :short_name);
      end

      #mine!
      #no destroy remember_token here?
      def signed_out_user
         redirect_to root_path unless !signed_in?
      end

   
end
