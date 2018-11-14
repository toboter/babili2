class Settings::MembershipsController < ApplicationController
  before_action :set_organization

  def destroy #leave
    @membership = @organization.memberships.find(params[:id])
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