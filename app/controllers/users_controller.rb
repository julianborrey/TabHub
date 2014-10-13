class UsersController < ApplicationController
   include TournamentsHelper
   include ApplicationHelper
   
   before_action :authenticate_user!
   before_action :user_signed_in?,  only: [:show, :destroy, :edit, :update] 
   before_action :correct_user,     only: [:edit, :update, :tournaments]
   before_action :signed_out_user,  only: [:new, :create]
   
   #def index
   #   @users = User.paginate(page: params[:page])
   #end
   
   def show
      @user = get_confirmed_user(params[:id]);
      
      #if unconfirmed or bogus user
      if @user.nil?
      	redirect_to root_path;
      	return;
      end

      #they will have settings of privacey that we need to check
      #4 modes. private, public to other debaters, public to others of my institution, public to the world
      #for now not implemented
      #implement here and views will do nothing if [] --> empty array
      #only one check, not multiple which could screw up, also best here to lower processing time
      #in implementation we need to see if the tournament wanted to be public ####################

      @tour_list = get_user_attendence(@user);
      @tour_list[:future].sort!  { |x,y| y.tournament.start_time <=> x.tournament.start_time } #descending time order
      @tour_list[:present].sort! { |x,y| y.tournament.start_time <=> x.tournament.start_time } #descending time order
      @tour_list[:past].sort!    { |x,y| y.tournament.start_time <=> x.tournament.start_time } #descending time order
   end
   
   # def new
   #    @user = User.new();
   # end
   
   def admin_user
      redirect_to(root_path) unless current_user.admin?
   end
   
   # def create
   #    @user = User.new(user_params) #user_params comes from pirvate foo
      
   #    if @user.save #if save successful (doesn't return false/nil)
   #       sign_in @user

   #       #we will also set up their default conflict
   #       Conflict.new(user_id: @user.id, institution_id: @user.institution_id).save;

   #       flash[:success] = "Welcome to TabHub!";
   #       redirect_to(user_path(@user.id)) #not even using "user_url"
   #    else
   #       #redirect_to(signup_path, object: @user);
   #       render('users/new'); #render the new.html.erb template
   #    end
   # end
   
   # def destroy
   #    User.find(params[:id]).destroy
   #    flash[:success] = "User destroyed."
   #    redirect_to users_url
   # end
   
   # def edit
   #   @user = User.find(params[:id])
   # end
   
   # def update
   #    #save this to compare if updated
   #    oldInst_id = User.find(params[:id]).institution_id;
      
   #    #@user = User.find(params[:id])
   #    if @user.update_attributes(user_params)
         
   #       #if they updated institution, take it as they moved
   #       if @user.institution_id != oldInst_id;
   #          Conflict.new(user_id: params[:id], institution_id: @user.institution_id).save;
   #          flash[:success] = "Profile updated. Note that you now have your previous conflicts plus one for your new institution."
   #       else
   #          flash[:success] = "Profile update."
   #       end
   #       sign_in @user
   #       redirect_to @user
   #    else
   #       render 'edit';
   #    end
   # end
   
   def tournaments
      @user = current_user
      
      #make a lists of TA with the following priotities
      #live tournament in tab room
      #live tournament elsewise
      #upcoming tab room
      #upcoming elsewise
      #pure chronological
      
      live_ta = @user.get_tournament_attendees(:present).to_a;
      live_ta.sort! { |x,y| y.role <=> x.role };
      #since ca/dca > tabRoom > debater/adj, it works
      
      futu_ta = @user.get_tournament_attendees(:future).to_a;
      futu_ta.sort! { |x,y| y.role <=> x.role };
      
      past_ta = @user.get_tournament_attendees(:past).to_a;
      past_ta.sort! { |x,y| y.role <=> x.role };
      
      @list = {current: live_ta, future: futu_ta, past: past_ta};
      return @list;
   end
   
   private
      # def user_params #function to throw error if no :user input
      #                 #but to only give pass on the inputs in permit()
      #    p = params.require(:user).permit(:fname, :lname, :email, :institution_id, :password,
      #                                 :password_confirmation, :admin);
      # end
   
      ### before filters ###
      def correct_user
         @user = User.find(params[:id])
         redirect_to(root_path) unless (current_user.id == @user.id)
      end
      
      #mine!
      #no destroy remember_token here?
      def signed_out_user
         redirect_to root_path unless !user_signed_in?
      end
end
