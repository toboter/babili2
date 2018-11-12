class Settings::ProfilesController < ApplicationController
  before_action :set_user
  layout 'settings'

  def new
    set_meta_tags title: 'Generate Profile | Settings',
                  description: 'Edit profile page',
                  noindex: true,
                  nofollow: true

    @profile = @user.build_profile
  end
  
  def edit
    set_meta_tags title: 'Profile | Settings',
                  description: 'Edit profile page',
                  noindex: true,
                  nofollow: true

    redirect_to new_settings_profile_path unless @user.profile.present?
    @profile = @user.profile
  end

  def edit_namespace

  end

  def create
    @profile = @user.build_profile(profile_params)
    respond_to do |format|
      if @profile.save
        format.html { redirect_to edit_settings_profile_url, notice: 'Generated your profile.' }
        format.js
      else
        format.html { redirect_to edit_settings_profile_url, notice: 'Sorry! Something went wrong. Profile not generated.' }
        format.js
      end
    end
  end

  def update
    respond_to do |format|
      if @user.profile.update(profile_params)
        format.html { redirect_to edit_settings_profile_url, notice: 'Updated your profile.' }
        format.js
      else
        format.html { redirect_to edit_settings_profile_url, alert: 'Sorry! Something went wrong. Profile not updated.' }
        format.js
      end
    end
  end

  private
    def set_user
      @user = current_user
    end

    def profile_params
      params.require(:profile).permit(:namespace, :name, :location, :url, :about, :avatar)
    end
end
