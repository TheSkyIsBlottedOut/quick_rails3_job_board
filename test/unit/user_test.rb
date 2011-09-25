require 'test_helper'


class UserTest < ActiveSupport::TestCase
  fixtures :users
  
  test "Presence of required fields" do
    user = User.new
    assert user.invalid?, "Blank user not reading invalid."
    [:username, :passcrypt, :email].each do |k|
      assert user.errors[k].any?, "No presence validation errors for #{k.to_s}."
    end
  end
  
  test "Password must be SHA1" do
    bad_pass = users(:bad_password)
    assert bad_pass.invalid?, "Bad Password Fixture is not reading invalid."
    assert_nil((bad_pass.passcrypt =~ /[a-f0-9]{40}/), "Bad password fixture is matching SHA1.")
    good_pass = users(:user1)
    assert_equal Digest::SHA1.hexdigest('password'), good_pass.passcrypt, "User1 password != SHA1('password')."
  end
  
  test "Unique field testing" do
    dupe = User.new(users(:user1).dup.attributes)
    assert dupe.invalid?, "Duplicate user should be invalid."
    assert dupe.errors[:username].any?, "No validation errors for username."
    assert dupe.errors[:email].any?, "No validation errors for email."
  end
  
  test "Email must be valid" do
    user = users(:bad_email)
    assert user.invalid?, "Bad Email user should be invalid."
    assert user.errors[:email].any?, "No validation errors for bad email."
  end
  
  test "Validation token must work" do
    time = Time.now
    user = User.new(created_at: time)
    token = Digest::SHA1.hexdigest(user.created_at.to_s)
    assert_equal user.validation_token, token
  end
  
  test "User authentication" do
    user = users(:user1)
    assert User.authenticate(user.username, 'password')
    assert_nil User.authenticate('bad-username', 'bad-password')
  end
end
