class Settings::MembershipPolicy < ApplicationPolicy

  def create?
    !record.organization.private? and not user.in?(record.organization.users)
  end

  def destroy?
    record.user == user or Pundit.policy!(user, record.organization).update? and record.role != 'Admin'
  end
end