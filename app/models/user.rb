class User < ApplicationRecord
  include PublicActivity::Common
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :approver, class_name: "User", optional: true
  has_many :memberships, dependent: :destroy
  has_many :organizations, through: :memberships
  has_many :sessions, class_name: 'UserSession', dependent: :destroy
  has_many :secure_activities, -> { where key: ['user.sign_in', 'user.password_changed'] }, class_name: 'PublicActivity::Activity', as: :trackable
  has_one :profile, as: :owner, dependent: :destroy
  
  after_create :send_admin_mail
  after_update :send_approval_mail, if: :is_approved?
  around_update :track_password_change!, if: :needs_password_change_audit?

  scope :admin, -> { where admin: true }
  scope :approved, -> { where.not approved_at: nil }

  delegate :name, to: :profile

  def self.send_reset_password_instructions(attributes={})
    recoverable = find_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
    if !recoverable.approved?
      recoverable.errors[:base] << I18n.t("devise.failure.not_approved")
    elsif recoverable.persisted?
      recoverable.send_reset_password_instructions
    end
    recoverable
  end

  def approve!(approver)
    unless approved?
      self.approved_at = Time.now
      self.approver = approver
      return true if save
    else
      self.errors.add(:base, "Already approved")
    end
  end

  def approved?
    approved_at.present?
  end

  def active_for_authentication? 
    super && approved? 
  end

  def has_avatar?
    has_profile? && profile.avatar.present?
  end

  def has_profile?
    profile.present? && profile.persisted?
  end
  
  def inactive_message 
    approved? ? super : :not_approved
  end

  def name
    email
  end

  def send_admin_mail
    AdminMailer.new_user_waiting_for_approval(self).deliver
  end

  def send_approval_mail
    UserMailer.account_approved(self).deliver
  end

  def activate_session(options = {})
    new_session = sessions.new
    new_session.session_id = SecureRandom.hex(127)
    new_session.ip = options[:ip] if options[:ip]
    new_session.user_agent = options[:user_agent] if options[:user_agent]
    new_session.save
    purge_old_sessions
    self.create_activity action: :sign_in, owner: self, params: {origin_ip: new_session.ip.to_string}, recipient: self
    new_session.session_id
  end

  def exclusive_session(session_id)
    sessions.where('session_id != ?', session_id).delete_all
  end

  def session_active?(session_id)
    sessions.where(session_id: session_id).exists?
  end

  def purge_old_sessions
    sessions.order('created_at desc').offset(3).destroy_all
  end

  private

    def is_approved?
      approved_at_changed? && approved?
    end

    def needs_password_change_audit?
      encrypted_password_changed? && persisted?
    end

    def track_password_change!
      self.create_activity action: :password_changed, owner: self, params: {origin_ip: self.last_sign_in_ip}, recipient: self
    end

end
