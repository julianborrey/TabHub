class CreateTournamentSettings < ActiveRecord::Migration
  def change
    create_table :tournament_settings do |t|
      t.integer :format
      t.integer :registration
      t.integer :motion
      t.integer :tab
      t.integer :attendees
      t.integer :teams
      t.integer :privacy

      t.timestamps
    end
  end
end
