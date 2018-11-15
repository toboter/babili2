class Settings::UsersController < ApplicationController
  before_action :set_user, except: :index
  layout 'settings'

  def index
    authorize [:settings, User]
    set_meta_tags title: 'Users | Settings',
                  description: 'Admin users page',
                  noindex: true,
                  nofollow: true
    @users = policy_scope [:settings, User]
  end

  def approve
    authorize [:settings, @user]
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
    authorize [:settings, @user]
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
