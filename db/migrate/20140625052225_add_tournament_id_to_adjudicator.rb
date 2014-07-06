class AddTournamentIdToAdjudicator < ActiveRecord::Migration
  def change
    add_column :adjudicators, :tournament_id, :integer
  end
end
