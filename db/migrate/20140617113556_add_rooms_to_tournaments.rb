class AddRoomsToTournaments < ActiveRecord::Migration
  def change
    add_column :tournaments, :rooms, :text
  end
end
