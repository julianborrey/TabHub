class MotionsController < ApplicationController

   def index
   end
   
   def random_motion
   	safe_params = safe_random_motion_params();
   	
   	#all genres and all tournaments
   	if safe_params[:rand_genre] == 0
   		possible_motions = Motion.where(created_at: safe_params[:rand_start_year]..
   			                                         safe_params[:rand_end_year]);
   	elsif safe_params[:rand_genre] != 0
   		possible_motions = Motion.where(created_at: 		 safe_params[:rand_start_year]..
   			                                         		 safe_params[:rand_end_year],
   												  motion_genre_id: safe_params[:rand_genre]);
   	end
   	
   	chosenMotion = possible_motions.sample(); #select a random motion

		@motion = {}; #our json to return
   	if !chosenMotion.nil?     && !@motion.empty?
			@motion["wording"]      = chosenMotion[:wording];
			@motion["tournament"]   = chosenMotion.tournament.name;
			@motion["date"]	      = create_date(chosenMotion);
   	else #for testing blank db
   		@motion["wording"] 	   = "THBT BP debating is superior to APDA."
   		@motion["tournament"]   = "Hi Uni";
   		@motion["date"]         = "12/12/1212";
   	end

   	render(layout: false); #raw json text will be rendered
   end

   def filtered_motions
   	safe_params = safe_filtered_motion_params();
   	@motions = [];

   	#do the correct db query
   	if safe_params[:rand_genre] == 0 && safe_params[:rand_tournament] == 0
   		selected_motions = Motion.where(created_at: safe_params[:rand_start_year]..
   			                                         safe_params[:rand_end_year]);
   	elsif safe_params[:rand_genre] == 0 && safe_params[:rand_tournament] != 0
   		selected_motions = Motion.where(created_at: safe_params[:rand_start_year]..
   			                                         safe_params[:rand_end_year],
   			                             tournament_id: safe_params[:rand_tournament]);
   	elsif safe_params[:rand_genre] != 0 && safe_params[:rand_tournament] == 0
   		selected_motions = Motion.where(created_at: safe_params[:rand_start_year]..
   			                                         safe_params[:rand_end_year],
   												  motion_genre_id: safe_params[:rand_genre]);
   	elsif safe_params[:rand_genre] != 0 && safe_params[:rand_tournament] != 0
   		selected_motions = Motion.where(created_at: safe_params[:rand_start_year]..
   			                                         safe_params[:rand_end_year],
   												  tournament_id: safe_params[:rand_tournament],
                                         motion_genre_id: safe_params[:rand_genre]);
   	end

   	selected_motions.each{ |m|

   		genreArray = []; #clear array
   		rawGenres  = MotionGenre.find(m[:id]).motion_genres().to_a;
   		rawGenres.each { |mg|
   			genreArray.push(GlobalConstants::MOTION_GENRE_STR[mg[:genre_id]].titleize);
   		}

   		@motions.push({
   						  "wording"    =>  m[:wording], 
   						  "genres"     =>  genreArray, #m.genre,
   						  "tournament" =>  m[:tournament],
   						  "date"       => create_date(m)
   						  });
   	}

   	#for testing blank db
   	#if @motions.nil? || @motions.empty?
   	#	@motions = [{"wording" => "AAA", "genres" => ["BBB", "bbb"], "tournament" => "CCC", "date" => "DDD"}, 
   	#					{"wording" => "AAA", "genres" => ["BBB", "bbb"], "tournament" => "CCC", "date" => "DDD"}];
   	#end
   	render(layout: false);
   end

   private
   	def safe_random_motion_params
         return params.permit(:rand_start_year, 
         				  :rand_end_year, 
         				  :rand_genre);
      end

      def safe_filtered_motion_params
         return params.permit(:filter_start_year, 
         						   :filter_end_year, 
         						   :filter_genre, 
         						   :filter_tournament);
      end

      def create_date(m) #input motion, get back formated date
      	return (m[:modified_at].day + "/" + m[:modified_at].month + "/" + m[:modified_at].year);
      end
end
