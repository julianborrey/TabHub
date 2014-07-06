class AddRatingToTournamentAttendees < ActiveRecord::Migration
  def change
    add_column :tournament_attendees, :rating, :float
  end
end
