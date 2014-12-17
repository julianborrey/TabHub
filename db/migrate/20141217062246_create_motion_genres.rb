class CreateMotionGenres < ActiveRecord::Migration
  def change
    create_table :motion_genres do |t|
      t.integer :motion_id
      t.integer :genre_id

      t.timestamps
    end
  end
end
