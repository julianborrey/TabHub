class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.integer :tournament_id
      t.integer :round_id
      t.integer :user_id
      t.float :speaks
      t.integer :points

      t.timestamps
    end
  end
end
