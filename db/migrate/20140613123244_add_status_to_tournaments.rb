class AddStatusToTournaments < ActiveRecord::Migration
  def change
    add_column :tournaments, :status, :integer
  end
end
