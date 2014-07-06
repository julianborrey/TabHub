class AddRoundCounterToTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :round_counter, :integer
  end
end
