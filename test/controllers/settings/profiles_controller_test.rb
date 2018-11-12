require 'test_helper'

class Settings::ProfilesControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get settings_profile_edit_url
    assert_response :success
  end

  test "should get update" do
    get settings_profile_update_url
    assert_response :success
  end

end
