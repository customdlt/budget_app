require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new at login path" do
    get login_path
    assert_response :success
  end

  test "invalid email or password should display flash error" do
    post '/login', params: { session: setup_invalid_user }
    assert_equal 'Invalid username/password combination.', flash[:error]
    assert_response 401
  end

  test "valid login should redirect to  user page" do
    post '/login', params: { session: setup_valid_user }
    assert_redirected_to user_path(user)
  end

  test "flash message should disappear after giving a good user after bad user" do
    post '/login', params: { session: setup_invalid_user }
    assert_equal 'Invalid username/password combination.', flash[:error]
    post '/login', params: { session: setup_valid_user }
    assert_nil flash[:error]
  end

  private

  def setup_invalid_user
    {
      email: 'fake@fake.com',
      password: 'invalid123!'
    }
  end

  def setup_valid_user
    user = users(:one)
    { email: user.email, password: 'secret'}
  end
end
