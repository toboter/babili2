class Settings::OrganizationsController < ApplicationController
  layout 'settings'

  def index
    set_meta_tags title: "Teams | Settings",
                  description: "List of organization memberships"
    @active_memberships = current_user.memberships.joins(:organization).merge(Membership.active).includes(organization: :profile).order('profiles.name ASC')
    @applyments = @active_memberships.merge(Membership.not_approved)
    @memberships = @active_memberships.merge(Membership.approved)
  end

  def edit
    set_meta_tags title: "Edit | Teams | Settings",
                  description: "Edit an organization"
    @organization = Organization.find(params[:id])
    @users = User.all
  end

  def update
    @organization = Organization.find(params[:id])
    respond_to do |format|
      if @organization.update(organization_params)
        format.html { redirect_to edit_settings_organization_path(@organization), notice: 'Updates successfully applied!' }
        format.js
      else
        format.html { render :edit, notice: 'Sorry! Something went wrong. Nothing updated.' }
        format.js
      end
    end
  end

  def destroy
    @organization = Organization.find(params[:id])
    @organization.destroy
    redirect_to settings_organizations_url, notice: 'Removed organization.'
  end

  private
    def organization_params
      params.require(:organization).permit(
        :private, 
        profile_attributes: [:id, :namespace, :name, :location, :url, :about, :avatar],
        memberships_attributes: [:id, :user_id, :role, :active, :_destroy, :approved])
    end

end
