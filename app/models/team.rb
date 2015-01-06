class Team < ActiveRecord::Base
  validates :subdomain, format: { with: /\A((?!-)[A-Za-z0-9-]{1,63}(?<!-))\z/, message: "Must only contain letters, numbers and dashes. Must NOT end or begin with a dash." }

  has_many :users, through: :memberships
  has_many :memberships
end
