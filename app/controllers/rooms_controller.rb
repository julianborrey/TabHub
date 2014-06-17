class RoomsController < ApplicationController
   include TournamentHelper
   include RoomHelper
   
   before_action :authorized_for_tournament, only: [:create];
   before_action :authorized_for_room, only: [:show, :edit, :destroy, :update];
   #still a bit of a flaw with this room authorization thing...

   def show
      #this is purely for viewing stats and stuff
      #only for tab room officials
      #the room info will be displayed for users in the draw/another page
      @room = Room.find(params[:id]);
   end

   def edit
      @room = Room.find(params[:id]);
   end

   def update
      @room = Room.find(params[:id]);
      if @room.update_attributes(safe_params)
         redirect_to(tournament_path(params[:tournament_id]) + '/control/rooms');
      else
         @tournament = Tournament.find(params[:tournament_id]);
         render 'tournaments/rooms';
      end
   end

   def create
      room_params = safe_params;
      @room = Room.new(room_params);
      @room.place_id = 0; 
      
      if @room.save();
         #must add this room to the tournament list
         t = Tournament.find(params[:tournament_id]);
         rooms = t.rooms; #overly safe this thread...is there a shortcut?
         rooms.push(@room.id);
         t.update_attributes(rooms: rooms);
         
         redirect_to(tournament_path(params[:tournament_id])  + '/control/rooms');
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
         
         @tournament = Tournament.find(params[:id].to_i);
         render('tournaments/rooms');
      end
   end
   
   def destroy
      r = Room.find(params[:id]);
      #must remove from tourament list
      t = Tournament.find(params[:tournament_id]);
      rooms = t.rooms;
      rooms.reject! { |i| i == r.id }
      t.update_attributes(rooms: rooms);

      r.destroy();
      redirect_to(tournament_path(params[:tournament_id]) + "/control/rooms")
   end
   
   private
      def safe_params
         p = params.require(:room).permit(:name, :location, :remarks, :id);
         p[:institution] = p[:institution_id].to_i;
      end

end
