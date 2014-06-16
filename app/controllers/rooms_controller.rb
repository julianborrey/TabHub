class RoomsController < ApplicationController
   include TournamentsHelper
   
   before_action :authorized_for_tournament, only: [:destroy, :create];
   
   def create
      room_params = safe_params;
      room_params[:institution_id] = safe_id[:institution_id].to_i;
      @room = Room.new(room_params);
      @room.place_id = 0; 
      if @room.save();
         redirect_to(tournament_path(safe_id[:tournament_id].to_i)  + '/control/rooms');
      else
         err = @room.errors.messages;
         @room = Room.new;
         
         #weird ass bug!!! have to remake @room for some fricken reason
         @room.name = room_params[:name];
         @room.location = room_params[:location];
         @room.remarks  = room_params[:remarks];
         @room.institution_id = room_params[:institution_id];
         
         err.each { |k,v|
            puts("%%%%%%%%%%%%%%%%%%%%%%%%" + k.to_s + " " + v.to_s);
            @room.errors.add(k, v);
         }
         
         
         @tournament = Tournament.find(safe_id[:tournament_id].to_i);
         render('tournaments/rooms');
      end
   end
   
   def destroy
   end
   
   private
      def safe_params
         params.require(:room).permit(:name, :location, :remarks);
      end

      def safe_id
         params.permit(:tournament_id, :institution_id);
      end
   
end
