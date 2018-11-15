class Settings::MembershipsController < ApplicationController
  before_action :set_organization

  def create #apply
    @applyment = authorize([:settings, @organization.memberships.build(user: current_user, active: true, role: 'Guest')])
    respond_to do |format|
      if @applyment.last.save
        format.html { redirect_to @organization.profile, notice: "Successfully applied for #{@organization.name}." }
        format.js
      else
        format.html { redirect_back(fallback_location: root_url) }
        format.js
      end
    end
  end

  def destroy #leave
    @membership = @organization.memberships.find(params[:id])
    authorize [:settings, @membership]
    @membership.destroy unless @membership.role == 'Admin'
    respond_to do |format|
      format.html { redirect_to settings_organizations_path, notice: "Membership was successfully removed." }
    end
  end

  private
  def set_organization
    @organization = Organization.find(params[:organization_id])
  end

  def membership_params
    params.require(:membership).permit(:_delete, :user_id, :organization_id)
  end


end