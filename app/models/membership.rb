class Membership < ApplicationRecord
  ROLES = %w(Admin Member Guest)

  belongs_to :user
  belongs_to :organization
  belongs_to :approver, class_name: 'User'

  scope :approved, -> { where.not approved_at: nil }
  scope :admin, -> { where role: 'Admin' }
  scope :member, -> { where role: ['Admin', 'Member'] }
  scope :guest, -> { where role: 'Guest' }

end
