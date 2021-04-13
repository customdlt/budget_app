require 'test_helper'

class UserTest < ActiveSupport::TestCase

  setup do
    @test_user = User.new(
      username: 'fakeName',
      email: 'fake@fakeemail.com',
      password_digest:  '123abc!'
    )
  end

  test "user without email shouldn't be valid" do
    @test_user.email = nil
    assert @test_user.invalid?
  end

  test "user without username shouldn't be valid" do
    @test_user.username = nil
    assert @test_user.invalid?
  end

  test "user email should be a valid email format wise" do
    @test_user.email = 'testbademail'
    assert @test_user.invalid?
  end

  test "users with duplicate emails should be invalid" do
    # User fixture one has this email
    @test_user.email = 'test@test.com'
    assert @test_user.invalid?
  end

  test "test user should be valid" do
    assert @test_user.valid?
  end

  test "user email should be downcased through before_save" do
    uppercase_email = 'FAKE@FAKE.com'
    fake_user = User.new(
      username: 'fakeUser',
      email: uppercase_email,
      password_digest: '123abc!'
    )
    fake_user.save!
    assert_equal(fake_user.reload.email, uppercase_email.downcase)
  end
end
