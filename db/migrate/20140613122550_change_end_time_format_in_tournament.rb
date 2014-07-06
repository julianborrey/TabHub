class ChangeEndTimeFormatInTournament < ActiveRecord::Migration
  def change
    change_column :tournaments, :end_time, :string
  end
end
