class ChangeRemarksTypeInTournaments < ActiveRecord::Migration
  def change
    change_column :tournaments, :remarks, :text
  end
end
