class CreateAdjAssignments < ActiveRecord::Migration
  def change
    create_table :adj_assignments do |t|
      t.integer :user_id
      t.integer :tournament_id
      t.integer :round_id
      t.integer :room_draw_id
      t.boolean :chair

      t.timestamps
    end
  end
end
