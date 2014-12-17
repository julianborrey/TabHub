class RoundsController < ApplicationController
	include TournamentHelper

   #all tabbies
   before_action :authorized_for_round, only: [:edit, :update, :destroy, 
   														  :make_draw_progress]

   #DCA and CA's
   before_action :authorized_for_make_round, only: [:create, :make_draw, 
   																 :release_draw, :release_motion]

   def create
      @round = Round.new(); #user_params comes from private foo
      @round.tournament_id = round_params["tournament_id"].to_i;
      @round.status = GlobalConstants::ROUND_STATUS[:hidden]; #at first, no draw and not released
      @round.round_num = 0; #@round.tournament.rounds.count + 1;
      @round.motion = Motion.new(wording: round_params["motion_attributes"]["wording"],
                                 user_id: current_user.id);

      if @round.save #if save successful (doesn't return false/nil)
         redirect_to(tournament_path(@round.tournament) + '/control/rounds');
      else
         #redirect_to(signup_path, object: @user);
         @tournament = @round.tournament;
         render('tournaments/rounds'); #render the new.html.erb template
      end
   end
   
   def edit
     @round = Round.find(params[:id])    
   end
   
   def update
      @round = Round.find(params[:id]);
      
      #checking the institution exists and security
      redirect_to root_path unless !@round.nil?
      #should this be in all of them?
      
      
      if @round.motion.update_attributes(wording: round_params[:motion_attributes][:wording], user_id: current_user.id)
         #handle a successful update
         redirect_to(tournament_path(@round.tournament) + '/control/rounds');
      else
         render 'rounds/edit';
      end
   end

   def destroy
      @round = Round.find(params[:id]);
      t = @round.tournament;
      
      ### we hopefully, will not go down this path
      #we need to do a shift of numbers
      #t.rounds.each { |r|
      #   if r.round_num > @round.round_num #this needs to shift
      #      r.update_attribute(round_num: r.round_num - 1); #shift up ranking
      #   end
      #}

      ### Let us render the round_num column irrelevant...
      
      @round.destroy();
      redirect_to(tournament_path(t.id) + '/control/rounds');
   end

   #executes algorithm to build the next draw!
   def make_draw
   	next_round = @tournament.next_round();
   	if next_round.nil? #hack?
   		puts("HACK ###");
   		redirect_to root_path;
   	else
   		dm = DrawMaker::DrawMakerClass.new;
   		
   		#it can go off and do this
   		child_pid = fork do
   			dm.make_draw(next_round, :bp);
   			exit;
   		end

   		#ensure there is > 0 progress so that 
   		#the control page loads with a progress bar
   		if Tournament.find(@tournament[:id])[:progress] == 0
   			@tournament.update(progress: 0.01);
   		end
   		redirect_to (tournament_path(@tournament) + "/control");
   	end
   	return;
   end

   #reports on draw progress by sending JSON
   #renders page directly
   def make_draw_progress
   	@tournament = Tournament.find(params[:id]);
   	render(layout: false); #send the data directly
   end

   #changes bit in tourament to release the draw
   def release_draw
   	@tournament.next_round.update(draw_released: true);
   	redirect_to tournament_control_path(@tournament);
   end

   #release the motion and start the round
   def start_round
   	#check tournament is currently running
   	if @tournament[:status] == GlobalConstants::TOURNAMENT_STATUS[:present]
   		if @tournament[:round_counter] < @tournament.num_rounds #check not at max rounds
   			@tournament.update(round_counter: @tournament[:round_counter] + 1); #increment
   			@tournament.current_round.update(status: GlobalConstants::ROUND_STATUS[:round_started]);
   			redirect_to (tournament_path(@tournament) + '/control');
   			return;
   		else
   			puts("HACK ###");
   		end
   	else #if it was ... hack
   		puts("HACK ###");
   	end
   	redirect_to root_path
   	return;
   end

   def show_draw
      @tournament = Tournament.find(params[:id]);
      
      #need to make a list where there is one entry for each team
      #[... {team, draw} ...]
      @list = [];
      
      @tournament.next_round.room_draws { |rd|
         rd.teams.each { |t|
            arr = rd.adjudicators.to_a;
            
            adjs_arr = [];
            arr.each { |a|
               adjs_arr.push({name: a.user.full_name, chair: a[:chair] });
            }
            
            @list.push({team: t, room_draw: rd, adjs: adjs_arr});
         }
      }
      
      @list.sort_by! { |i| i[:team].name.downcase; } #makes alphabetical
   end
   
   private
      def round_params #permit only said inputs
         params.require(:round).permit(:id, :round_num, :tournament_id, :motion_attributes => [:wording]);
         #^ the lazy mans way
      end


      def authorized_for_round
         @tournament = Round.find(params[:id]).tournament;
         redirect_to tournament_path(@t) unless current_user.is_a_tabbie?(@tournament);
      end

      #checks that the user is ca/dca
      def authorized_for_make_round
         @tournament = Tournament.find(params[:id]);
         redirect_to illegal_access_path("make_round") unless current_user.is_a_tabbie?(@tournament);
      end
end
