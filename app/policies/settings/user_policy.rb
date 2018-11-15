class Settings::UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.order(approved_at: :asc, created_at: :desc)
    end
  end

  def index?
    user.admin?
  end

  def approve?
    user.admin?
  end

  def make_admin?
    user.admin?
  end

end