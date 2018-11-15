class Profile < ApplicationRecord
  include Uploader::AvatarUploader[:avatar]
  extend FriendlyId
  friendly_id :namespace, use: :slugged  #????
  # shrine

  belongs_to :owner, polymorphic: true
  has_many :schemes, dependent: :destroy, class_name: 'Vocabulary::Scheme'

  validates :namespace, presence: :true

  scope :visible, -> { where private: false }

  def title
    name.presence || slug
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
