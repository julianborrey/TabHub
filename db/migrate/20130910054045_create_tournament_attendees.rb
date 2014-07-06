class CreateTournamentAttendees < ActiveRecord::Migration
  def change
    create_table :tournament_attendees do |t|
      t.integer :tournament_id
      t.integer :user_id
      t.integer :role

      t.timestamps
    end
  end
end
