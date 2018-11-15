class Settings::SecurityPolicy < Struct.new(:user, :security)

  def show?
    user.present?
  end

end