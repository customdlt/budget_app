require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "home page should be root url" do
    get root_url
    assert_response :success
  end

  test "help page should be accessible" do
    get help_path
    assert_response :success
  end

end
