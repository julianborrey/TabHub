class RenameRoundIdToRoomDrawIdInAdjudicator < ActiveRecord::Migration
  def change
    rename_column :adjudicators, :round_id, :room_draw_id
  end
end
