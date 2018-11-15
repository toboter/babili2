class Settings::OrganizationsController < ApplicationController
  before_action :set_organization, except: :index
  layout 'settings'

  def index
    set_meta_tags title: "Teams | Settings",
                  description: "List of organization memberships"
    @organizations = policy_scope([:settings, Organization])
    @applied_organizations = @organizations.merge(Membership.not_approved)
    @approved_organizations = @organizations.merge(Membership.approved)
  end

  def edit
    set_meta_tags title: "Edit | Teams | Settings",
                  description: "Edit an organization"
    
    authorize [:settings, @organization]
    @users = User.all
  end

  def update
    authorize [:settings, @organization]
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
    authorize [:settings, @organization]
    @organization.destroy
    redirect_to settings_organizations_url, notice: 'Removed organization.'
  end

  private
  def organization_params
    params.require(:organization).permit(
      profile_attributes: [:id, :namespace, :name, :location, :url, :about, :avatar, :private],
      memberships_attributes: [:id, :user_id, :role, :active, :_destroy, :approved])
  end

  def set_organization
    @organization = Organization.find(params[:id])
  end

end
