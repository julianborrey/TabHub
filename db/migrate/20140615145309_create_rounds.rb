class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds do |t|
      t.integer :tournament_id
      t.integer :motion_id
      t.string :start_time
      t.string :end_prep_time
      t.integer :status
      t.integer :round_num

      t.timestamps
    end
  end
end
