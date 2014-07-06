class DropRoomDrawTable < ActiveRecord::Migration
  def change
    drop_table :room_draws
  end
end
