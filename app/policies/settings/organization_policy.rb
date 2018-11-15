class Settings::OrganizationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
        .joins(:memberships, :profile)
        .where(memberships: {user: user})
        .merge(Membership.active)
        .order('profiles.name ASC')
    end
  end

  def update?
    record.in?(user.organizations.merge(Membership.active).merge(Membership.admin))
  end

  def destroy?
    record.in?(user.organizations.merge(Membership.active).merge(Membership.admin))
  end
end