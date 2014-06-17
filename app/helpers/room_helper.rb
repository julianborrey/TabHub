module RoomHelper
   
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
   
end
