class Membership < ApplicationRecord
  ROLES = %w(Admin Member Guest)

  belongs_to :user
  belongs_to :organization
  belongs_to :approver, class_name: 'User', optional: true

  scope :approved, -> { where.not approved_at: nil }
  scope :not_approved, -> { where approved_at: nil }
  scope :admin, -> { where role: 'Admin' }
  scope :member, -> { where role: ['Admin', 'Member'] }
  scope :guest, -> { where role: 'Guest' }
  scope :active, -> { where active: true }
  scope :inactive, -> { where active: false }

  attr_accessor :approved

  def approved
    approved_at.present?
  end

  def approved=(value)
    if user = User.where(id: value).first
      self.approved_at = Time.now
      self.approver = user
    elsif value == 'false'
      self.approved_at = nil
      self.approver_id = nil
    end
  end

end
