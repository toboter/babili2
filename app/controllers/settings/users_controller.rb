class Settings::UsersController < ApplicationController
  before_action :set_user, except: :index
  layout 'settings'

  def current_ability
    @current_ability ||= UserAbility.new(current_user)
  end

  def index
    set_meta_tags title: 'Users | Settings',
                  description: 'Admin users page',
                  noindex: true,
                  nofollow: true 
    @users = User.order(approved_at: :asc, created_at: :desc).accessible_by(current_ability, :index)
  end

  def approve
    respond_to do |format|
      if @user.approve!(current_user)
        format.html { redirect_to settings_users_url, notice: 'Approved user.' }
        format.js
      else
        format.html { redirect_to settings_users_url, notice: 'Error.' }
        format.js
      end
    end
  end

  def make_admin
    respond_to do |format|
      if current_user.admin? && @user.update(user_params)
        format.html { redirect_to settings_users_url, notice: 'Updated user roles.' }
        format.js
      else
        format.html { redirect_to settings_users_url, notice: 'Error.' }
        format.js
      end
    end
  end

  private
    def user_params
      params.require(:user).permit(:id, :admin)
    end

    def set_user
      @user = User.find(params[:id])
    end

end
