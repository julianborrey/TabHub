class CreateRoomDraws < ActiveRecord::Migration
  def change
    create_table :room_draws do |t|
      t.integer :tournament_id
      t.integer :round_id
      t.integer :room_id
      t.integer :og_id
      t.integer :oo_id
      t.integer :cg_id
      t.integer :co_id
      t.integer :first_id
      t.integer :second_id
      t.integer :third_id
      t.integer :fourth_id
      t.integer :status

      t.timestamps
    end
  end
end
