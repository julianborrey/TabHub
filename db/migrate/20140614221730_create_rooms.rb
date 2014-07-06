class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :name
      t.string :location
      t.string :remarks
      t.integer :institution_id
      t.integer :place_id

      t.timestamps
    end
  end
end
