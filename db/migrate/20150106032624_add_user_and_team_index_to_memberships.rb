class AddUserAndTeamIndexToMemberships < ActiveRecord::Migration
  def change
    add_index(:memberships, [:team_id, :user_id], unique: true)
  end
end
