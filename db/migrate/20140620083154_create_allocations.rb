class CreateAllocations < ActiveRecord::Migration
  def change
    create_table :allocations do |t|
      t.integer :tournament_id
      t.integer :institution_id
      t.integer :num_teams
      t.integer :num_adjs
      t.boolean :live

      t.timestamps
    end
  end
end
