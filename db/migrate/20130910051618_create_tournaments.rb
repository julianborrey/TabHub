class CreateTournaments < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|
      t.string :name
      t.integer :institution_id
      t.string :location
      t.datetime :start_time
      t.datetime :end_time
      t.text :remarks
      t.integer :user_id

      t.timestamps
    end
  end
end
