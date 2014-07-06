module RoomsHelper
   
   #true is the user is in the tab room of a current tournament for thei institution
   def authorized_for_room
      #check that this room is in their tournament
      #and that this is a tournament they are in the tab room for
         
      #check authorized for tournament
      if current_user.in_tab_room?(params[:tournament_id])
         if Tournament.find(params[:tournament_id].to_i).rooms.include?(params[:id].to_i) #check room in tournament
            return true;
         end
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
      
      #we must remove anywhich are already in the current tournament
      #...damn, this is O(m*n) ...
      list.reject! { |r| t.rooms.include?(r.id) }
      return list;
   end
   
end
