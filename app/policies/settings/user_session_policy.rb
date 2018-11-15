class Settings::UserSessionPolicy < ApplicationPolicy

  def destroy?
    user == record.user
  end

end