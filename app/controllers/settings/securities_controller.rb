class Settings::SecuritiesController < ApplicationController
  layout 'settings'

  def show
    set_meta_tags title: "Security overview | Settings",
                  description: "Personal security overview and action audits",
                  noindex: true,
                  nofolow: true
    @secure_activities = current_user.secure_activities.order(created_at: :desc).limit(20)
    @recent_sessions = current_user.sessions
  end
  
end
