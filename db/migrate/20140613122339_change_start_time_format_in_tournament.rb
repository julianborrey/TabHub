class ChangeStartTimeFormatInTournament < ActiveRecord::Migration
  def change
    change_column :tournaments, :start_time, :string
  end
end
