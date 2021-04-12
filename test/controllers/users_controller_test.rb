require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new as signup" do
    get signup_path
    assert_response :success
  end

  test "user should be redirect from user page if not logged in." do
    get user_path(1)
    assert_redirected_to login_path
  end

  test "should be able to create user and go to profile page" do
    assert_difference 'User.count' do
      post "/users", params: { user: setup_user_params}
    end
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select(
      '.user-profileHeader',
      "Welcome #{setup_user_params[:username]}, " \
      "you have a budget of #{ActiveSupport::NumberHelper.number_to_currency(
        setup_user_params[:budget_attributes][:amount]
        )
      } remaining."
    )
  end

  private

  def setup_user_params
    {
      username: 'testUser',
      email: 'testemail@fakeemail.com',
      password: 'abc123!',
      password_confirmation: 'abc123!',
      budget_attributes: { amount: 20.00 }
    }
  end
end
