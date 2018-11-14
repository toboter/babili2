class OrganizationsController < ApplicationController
  def index
    @organizations = Organization.visible
  end
end
