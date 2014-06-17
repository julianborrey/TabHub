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
            #uncomment below, the bug appears
            #@room.errors.add(k, v);
         }
         
         #manual errors for now ;(
         if @room.name.empty?
            #@room.errors.add(:name, "cannot not be blank.");
         end
         #even that failed
         
         @tournament = Tournament.find(safe_id[:tournament_id].to_i);
         render('tournaments/rooms');
      end
   end
   
   def destroy
      r = Room.find(safe_id[:id]);

      #find the tournament this relates to by records
      list_tourns = r.institution.tournaments.to_a; #all possible tournaments for this room
      list_tourns.reject! { |t| t.id != safe_id[:tournament_id].to_i } #remove irrelevants
      puts("our list is: " +list_tourns.to_s);
      
      if list_tourns.count != 1 #should only have one tournament now
         puts("Hacker @ 002");
         redirect_to root_path;
      else #now check they have authority
         if current_user.in_tab_room?(list_tourns.first)
            r.destroy();
            redirect_to(tournament_path(safe_id[:tournament_id].to_i) + '/control/rooms');
         else
            puts("Hacker @ 003");
            redirect_to root_path;
         end
      end
   end
   
   private
      def safe_params
         params.require(:room).permit(:name, :location, :remarks, :id);
      end

      def safe_id
         params.permit(:tournament_id, :institution_id, :id);
      end
   
end
