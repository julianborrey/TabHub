class CreateConflicts < ActiveRecord::Migration
  def change
    create_table :conflicts do |t|
      t.integer :user_id
      t.integer :institution_id

      t.timestamps
    end
  end
end
