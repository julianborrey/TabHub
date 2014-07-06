class AddTournamentIdToTournamentSettings < ActiveRecord::Migration
  def change
    add_column :tournament_settings, :tournament_id, :integer
  end
end
