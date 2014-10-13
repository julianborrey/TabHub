module RoomHelper
   
   #true is the user is in the tab room of a current tournament for thei institution
   def authorized_for_room
      #check that this room is in their tournament
      #and that this is a tournament they are in the tab room for

      @tournament = nil;
      if params["tournament_id"] != nil
      	@tournament = Tournament.find(params["tournament_id"]);
      end
         
      #check authorized for tournament
      if !@tournament.nil? && current_user.is_in_roles?([:tab_room, :ca, :dca], @tournament)
         if Tournament.find(params[:tournament_id].to_i).rooms.include?(params[:id].to_i) #check room in tournament
            return true;
         end
      end

      #check that the user has the institutional power to view room
      if current_user.president? && current_user.institution.rooms.include?(params[:id].to_i);
      	return true;
      end

      #if we got here...refuse authorization
      redirect_to root_path
   end
   
   #returns list of rooms from other tournaments
   def get_past_rooms
      hash = {}; #return value
      
      #find the relavent tournament
      t = Tournament.find(params[:id]);
      
      #now we make a list of all the rooms belonging
      #to this institution
      list = t.institution.rooms.to_a;
      list = list + current_user.institution.rooms.to_a;

      #we must remove anywhich are already in the current tournament
      #...damn, this is O(m*n) ...
      list.reject! { |r| t.rooms.include?(r.id) }
      return list;
   end
   
end
