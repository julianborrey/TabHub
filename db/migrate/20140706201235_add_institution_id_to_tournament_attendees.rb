class AddInstitutionIdToTournamentAttendees < ActiveRecord::Migration
  def change
    add_column :tournament_attendees, :institution_id, :integer
  end
end
