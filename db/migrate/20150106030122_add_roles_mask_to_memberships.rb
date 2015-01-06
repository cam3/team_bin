class AddRolesMaskToMemberships < ActiveRecord::Migration
  def change
    add_column :memberships, :roles_mask, :integer
  end
end
