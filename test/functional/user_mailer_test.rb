require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  fixtures :users
  test "Welcome Email Response" do
    user = users(:user1)
    response = UserMailer.welcome_email(user)
    assert_equal response.subject, "Welcome to the Job Board!"
  end
end
