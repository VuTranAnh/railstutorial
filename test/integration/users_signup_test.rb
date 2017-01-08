require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup" do
    get signup_path
    assert_no_difference "User.count" do
      post users_path,
        params: {user: {name: "", email: "user@invalidi", password: "aaaa",
          password_confirmation: "aaaaa"}}
    end
    assert_template "users/new"
  end

  test "valid signup" do
    get signup_path
    assert_difference "User.count", 1 do
      post users_path,
        params: {user: {name: "example", email: "example@example.com",
          password: "123456", password_confirmation: "123456"}}
    end
    follow_redirect!
  end
end
