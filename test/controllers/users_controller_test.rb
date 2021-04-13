require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new user as signup" do
    get signup_path
    assert_response :success
  end

  test "user should be redirect from user page if not logged in." do
    get user_path(1)
    assert_redirected_to login_path
  end

  test "user should fail create if they don't have a username on sign up" do
    user_attributes = setup_user_params
    user_attributes[:username] = nil
    assert_no_difference 'User.count' do
      post "/users", params: { user: user_attributes }
      assert_equal "Username can't be blank", flash[:error]
    end
  end

  test "user should fail create if there isn't a budget amount" do
    user_attributes = setup_user_params
    user_attributes[:budget_attributes][:amount] = nil
    assert_no_difference 'User.count' do
      post "/users", params: { user: user_attributes }
      assert_equal "Budget amount can't be blank", flash[:error]
    end
  end

  test "user should fail create if there isn't a password on sign up" do
    user_attributes = setup_user_params
    user_attributes[:password]= nil
    user_attributes[:password_confirmation] = nil
    assert_no_difference 'User.count' do
      post "/users", params: { user: user_attributes }
      assert_equal "Password can't be blank", flash[:error]
    end
  end

  test "should be able to create user and redirect to show user" do
    assert_difference 'User.count' do
      post "/users", params: { user: setup_user_params }
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
