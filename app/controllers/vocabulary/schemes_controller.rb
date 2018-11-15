module Vocabulary
  class SchemesController < ApplicationController
    before_action :set_profile
    
    def index
      @schemes = @profile.schemes
    end

    private
    def set_profile
      @profile = Profile.friendly.find(params[:profile_id])
    end

  end
end