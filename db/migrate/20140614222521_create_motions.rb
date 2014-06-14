class CreateMotions < ActiveRecord::Migration
  def change
    create_table :motions do |t|
      t.string :wording
      t.integer :user_id
      t.integer :tournament_id
      t.integer :round_id

      t.timestamps
    end
  end
end
