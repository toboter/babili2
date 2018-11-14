require 'test_helper'

class Settings::OrganizationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get settings_organizations_index_url
    assert_response :success
  end

end
