class MembershipsController < ApplicationController
  before_action :set_organization

  def create #apply
    @applyment = current_user.memberships.new(organization: @organization, active: true, role: 'Guest')
    respond_to do |format|
      if @applyment.save
        format.html { redirect_to @organization.profile, notice: "Successfully applied for #{@organization.name}." }
        format.js
      else
        format.html { redirect_back(fallback_location: root_url) }
        format.js
      end
    end
  end

  private
  def set_organization
    @organization = Organization.find(params[:organization_id])
  end

end