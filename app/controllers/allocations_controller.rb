class AllocationsController < ApplicationController

############ Control Methods #################
   
   #allocates team or adj spots to given institution
   def allocate_by_tabbie
      Allocation.new(tournament_id: params[:id], 
                     institution_id: safe_params[:allocation][:institution_id],
                     num_teams: safe_params[:num_teams],
                     num_adjs:  safe_params[:num_adjs],
                     live: true).save;
      
      flash[:success] = "Spots allocated"
      redirect_to(tournament_path(params[:id]) + '/control/institutions');
   end
   
   private
      def safe_params
         params.permit(:num_teams, :num_adjs, allocation: [:institution_id]);
      end

end
