require 'test_helper'

class Settings::SecuritiesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get settings_securities_show_url
    assert_response :success
  end

end
