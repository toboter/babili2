class Setup::OrganizationsController < ApplicationController

  def new
    @organization = Organization.new(creator: current_user)
  end

  def memberships
    @organization = Organization.find(params[:id])
    @organization.memberships.build(user: current_user, approver: current_user, approved_at: Time.now, role: 'Admin', active: true) unless @organization.users.include?(current_user)
    render 'edit_memberships'
  end

  def details
    @organization = Organization.find(params[:id])
    render 'edit_details'
  end

  def create
    @organization = Organization.new(organization_params)
    @organization.creator = current_user
    respond_to do |format|
      if @organization.save
        format.html { redirect_to memberships_setup_organization_path(@organization), notice: 'Successfully set up your new team!' }
        format.js
      else
        format.html { render :new, notice: 'Sorry! Something went wrong. Team not created.' }
        format.js
      end
    end
  end

  def update_memberships
    @organization = Organization.find(params[:id])
    respond_to do |format|
      if @organization.update(organization_params)
        format.html { redirect_to details_setup_organization_path(@organization), notice: 'Successfully invited new teammates!' }
        format.js
      else
        format.html { redirect_to :memberships, notice: 'Sorry! Something went wrong. Nobody invited.' }
        format.js
      end
    end
  end

  def update_details
    @organization = Organization.find(params[:id])
    respond_to do |format|
      if @organization.update(organization_params)
        format.html { redirect_to profile_path(@organization.profile), notice: 'Successfully finalized group!' }
        format.js
      else
        format.html { redirect_to :details, notice: 'Sorry! Something went wrong. Nobody invited.' }
        format.js
      end
    end
  end

  private
    def organization_params
      params.require(:organization).permit(
        :private, 
        profile_attributes: [:namespace, :name, :location, :url, :about, :avatar],
        memberships_attributes: [:id, :user_id, :role, :active, :approved_at, :approver_id, :_destroy])
    end

end
