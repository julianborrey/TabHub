class ChangeColumnMember1AndMember2InTeamToMember1IdAndMember2Id < ActiveRecord::Migration
  def change
    rename_column :teams, :member_1, :member_1_id
    rename_column :teams, :member_2, :member_2_id
  end
end
