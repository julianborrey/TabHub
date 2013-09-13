class UsersController < ApplicationController
   before_action :signed_in_user,  only: [:show, :destroy, :edit, :update] 
   before_action :correct_user,    only: [:edit, :update]
   before_action :signed_out_user, only: [:new, :create]
   
   #def index
   #   @users = User.paginate(page: params[:page])
   #end
   
   def show
      @user = User.find(params[:id])
      
      #get past tournaments data
      attend_list = TournamentAttendee.where("user_id = ?", @user.id);

      @tour_list = []; #put each tournament into a list from relationship table
      attend_list.each { |e| @tour_list.push(Tournament.find(e.tournament_id)) }
      @tour_list.sort! { |x,y| y.start_time <=> x.start_time } #descending time order
   end
   
   def new
      @user = User.new();
   end
   
   def admin_user
      redirect_to(root_path) unless current_user.admin?
   end
   
   def create
      @user = User.new(user_params) #user_params comes from pirvate foo
      
      if @user.save #if save successful (doesn't return false/nil)
         sign_in @user
         redirect_to(user_path(@user.id)) #not even using "user_url"
      else
         #redirect_to(signup_path, object: @user);
         render('users/new'); #render the new.html.erb template
      end
   end
   
   def destroy
      User.find(params[:id]).destroy
      flash[:success] = "User destroyed."
      redirect_to users_url
   end
   
   def edit
     #@user = User.find(params[:id])
   end
   
   def update
      #@user = User.find(params[:id])
      if @user.update_attributes(user_params)
         #handle a successful update
         flash[:success] = "Profile updated"
         sign_in @user
         redirect_to @user
      else
         render 'edit';
      end
   end
   
   private
      def user_params #function to throw error if no :user input
                      #but to only give pass on the inputs in permit()
         params.require(:user).permit(:fname, :lname, :email, :institution_id, :password,
                                      :password_confirmation, :admin)
      end
   
      ### before filters ###
      def correct_user
         @user = User.find(params[:id])
         redirect_to(root_path) unless current_user?(@user)
      end
      
      #mine!
      def signed_out_user
         redirect_to root_path unless !signed_in?
      end
end
