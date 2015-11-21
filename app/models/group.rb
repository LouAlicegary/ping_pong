class Group < ActiveRecord::Base

  has_many :group_memberships
  has_many :players, through: :group_memberships

end
