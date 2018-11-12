# app/abilities/user_ability.rb
class UserAbility
  include CanCan::Ability

  def initialize(user)
    can :edit, User, id: user.id
    can [:index, :approve, :make_admin], User if user.admin?
  end

end