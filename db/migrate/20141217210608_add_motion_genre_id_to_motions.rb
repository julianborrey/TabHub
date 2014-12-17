class AddMotionGenreIdToMotions < ActiveRecord::Migration
  def change
    add_column :motions, :motion_genre_id, :integer
  end
end
