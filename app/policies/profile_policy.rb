class ProfilePolicy < ApplicationPolicy

  def show?
    !record.private? or user.in?(record.owner.users.merge(Membership.approved))
  end

  def update?
    user.admin?
  end
end

# can :read, Profile
# cannot :read, Profile, private: true
# can :read, Profile, id: user.organizations_profiles.merge(Membership.approved)