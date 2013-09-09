class FixColumnName < ActiveRecord::Migration
   def change
      rename_column :users, :institution, :institution_id
   end
end
