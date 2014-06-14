class CreateAdjudicators < ActiveRecord::Migration
  def change
    create_table :adjudicators do |t|
      t.integer :user_id
      t.integer :round_id
      t.boolean :chair

      t.timestamps
    end
  end
end
