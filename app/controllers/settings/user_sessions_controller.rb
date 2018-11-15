class Settings::UserSessionsController < ApplicationController

  def destroy
    @session = current_user.sessions.find(params[:id])
    authorize [:settings, @session]
    @session.destroy
    respond_to do |format|
      format.html { redirect_to security_settings_url, notice: 'Successfully killed session!' }
      format.json { head :no_content }
      format.js
    end
  end

end