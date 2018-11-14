class Profile < ApplicationRecord
  include AvatarUploader[:avatar]
  extend FriendlyId
  friendly_id :namespace, use: :slugged  #????
  # shrine

  belongs_to :owner, polymorphic: true

  validates :namespace, presence: :true

  def name
    super.presence || slug
  end

  def organization?
    owner_type == 'Organization'
  end

  def user?
    owner_type == 'User'
  end

  def should_generate_new_friendly_id?
    namespace_changed? || super
  end
end
