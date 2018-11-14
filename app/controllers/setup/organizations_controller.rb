class Setup::OrganizationsController < ApplicationController
  include Wicked::Wizard
  steps :basics, :invite, :details

  def show
    @organization = Organization.find(params[:organization_id])
    render_wizard
  end

  def create
    @organization = Organization.create(creator: current_user)
    respond_to do |format|
      if @organization.save
        format.html { redirect_to wizard_path(steps.first, organization_id: @organization.id) }
        format.js
      else
        format.html { redirect_back fallback_location: root_path, alert: 'Sorry! Something went wrong. Team not created.' }
        format.js
      end
    end
  end

  def update
    @organization = Organization.find(params[:organization_id])
    @organization.update(organization_params)
    render_wizard @organization
  end

  private
    def organization_params
      params.require(:organization).permit(
        :private, 
        profile_attributes: [:namespace, :name, :location, :url, :about, :avatar],
        memberships_attributes: [:id, :user_id, :role, :active, :approved_at, :approver_id, :_destroy])
    end

    def finish_wizard_path
      profile_path(@organization)
    end

end
