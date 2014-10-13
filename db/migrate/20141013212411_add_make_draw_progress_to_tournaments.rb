class AddMakeDrawProgressToTournaments < ActiveRecord::Migration
  def change
    add_column :tournaments, :progress, :float
  end
end
