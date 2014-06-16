class AddTournamentSettingIdToTournaments < ActiveRecord::Migration
  def change
    add_column :tournaments, :tournament_setting_id, :integer
  end
end
