class OrganizationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.merge(Profile.visible)
    end
  end

  # can create a new organization through the setup process
  def show?; true end
  def create?; true end
  def update?; true end

end