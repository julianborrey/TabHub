class CreateRoomDraws < ActiveRecord::Migration
  def change
    create_table :room_draws do |t|
      t.integer :tournament_id
      t.integer :round_id
      t.integer :room_id
      t.integer :og
      t.integer :oo
      t.integer :cg
      t.integer :co
      t.integer :first
      t.integer :second
      t.integer :third
      t.integer :fourth
      t.integer :status

      t.timestamps
    end
  end
end
