class RoomsController < ApplicationController
   include RoomHelper
   
   before_action :authorized_for_room, only: [:create, :edit, :update, :show];
   #before_action :authorized_for_room, only: [:show, :update];
   #still a bit of a flaw with this room authorization thing...
   
   def show
      #this is purely for viewing stats and stuff
      #only for tab room officials
      #the room info will be displayed for users in the draw/another page
      @room = Room.find(params[:id]);

      #need to find institution in a similar way
      @institution = nil;
   end
   
   def edit
      @room = Room.find(params[:id]);
   end
   
   def update
      @room = Room.find(params[:id]);
      
      @tournament = nil;
      if params["tournament_id"] != nil
      	@tournament = Tournament.find(params["tournament_id"]);
      end

      if @room.update_attributes(room_params)
         flash[:success] = "Room updated.";
         redirect_to(room_path(id: @room[:id], tournament_id: @tournament[:id]));
      else
         render 'rooms/edit';
      end
   end
   
   def create
      @room = Room.new(room_params);
      @room.place_id = 0; 
      @flash = [];

      if @room.save();
         #must add this room to the tournament list
         t = Tournament.find(params[:tournament_id]);
         rooms = t.rooms; #overly safe this thread...is there a shortcut?
         rooms.push(@room.id);
         t.update_attributes(rooms: rooms);
         
         redirect_to(tournament_path(params[:tournament_id])  + '/control/rooms');
      else
         @room.errors.messages.each { |k,v|
            v.each { |s|
               @flash.push(k.to_s.capitalize + " " + s + ".");
            }
         }
         
         @room.errors.clear; #comment this out, bug appears (WTF is this thing?)
         @tournament = Tournament.find(params[:tournament_id].to_i);
         render('tournaments/rooms');
      end
   end
   
  ######## since we do not have a relational db between rooms and tournaments
  ######## we will not have a delete...impossible to know if a room is used in
  ######## a tournament or not...don't want to have broken db.
  # def destroy
  #    r = Room.find(params[:id]);
  #    #must remove from tourament list if it is in the current one
  #    t = Tournament.find(params[:tournament_id]);
  #    rooms = t.rooms;
  #    rooms.reject! { |i| i == r.id }
  #    t.update_attributes(rooms: rooms);
  #
  #    r.destroy();
  #    redirect_to(tournament_path(params[:tournament_id]) + "/control/rooms")
  # end
   
   private
      def safe_params
         p = params.require(:room).permit(:name, :location, :remarks, :id, :institution_id, :tournament_id);
         p["institution_id"] = params["institution_id"].to_i; #hole?
         p["tournament_id"] = params["tournament_id"].to_i; #hole?
         return p;
      end

      def room_params
      	p = safe_params;
      	p.delete(:tournament_id); #not included in the room
      	return p;
      end
      
end
