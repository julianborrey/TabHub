class AddShowMembersToInstitutions < ActiveRecord::Migration
  def change
    add_column :institutions, :show_members, :boolean
  end
end
