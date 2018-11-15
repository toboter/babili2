class Settings::UserProfilePolicy < ApplicationPolicy

  def create?
    user.present?
  end

  def update?
    user.profile.present? and user == record.last.owner
  end

end