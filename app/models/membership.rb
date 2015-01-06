class Membership < ActiveRecord::Base
  validates_uniqueness_of :user_id, scope: :team_id, message: "already a member of the team."

  belongs_to :team
  belongs_to :user

  include RoleModel
  roles :creator, :manager
end
