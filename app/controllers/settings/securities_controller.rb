class Settings::SecuritiesController < ApplicationController
  layout 'settings'

  def show
    authorize [:settings, :security]
    set_meta_tags title: "Security overview | Settings",
                  description: "Personal security overview and action audits",
                  noindex: true,
                  nofolow: true
    @vital_activities = current_user.vital_activities.order(created_at: :desc).limit(20)
    @recent_sessions = current_user.sessions
  end
  
end
