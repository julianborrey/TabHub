class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.integer :institution_id
      t.integer :tournament_id
      t.integer :member_1
      t.integer :member_2
      t.float :total_speaks
      t.integer :points

      t.timestamps
    end
  end
end
