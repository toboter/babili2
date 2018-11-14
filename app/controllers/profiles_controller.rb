class ProfilesController < ApplicationController
  def show
    @profile = Profile.friendly.find(params[:id])
    set_meta_tags title: "#{@profile.slug} | Profile",
                  description: "#{@profile.owner_type} profile page",
                  index: true,
                  follow: true

    @members = @profile.owner.users.merge(Membership.approved) if @profile.organization?
  end
end
