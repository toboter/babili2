class Organization < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships, class_name: 'User'
  has_one :profile, as: :owner, dependent: :destroy

  accepts_nested_attributes_for :profile, reject_if: proc { |attributes| attributes['namespace'].blank? }
  accepts_nested_attributes_for :memberships, reject_if: :all_blank, allow_destroy: true

  # validates :profile, presence: true

  delegate :name, :namespace, :about, :private?, to: :profile

  def orphan?
    !memberships.any?
  end

  def admins
    users.merge(Membership.admin).presence || [creator]
  end

end
