require 'test_helper'

class LoginControllerTest < ActionController::TestCase
  setup do
    @test_attributes = {username: 'keep-this-space-unique', passcrypt: 'abcdefg', email: 'keep-this-email-unique@def.com'}
  end
  
  test "should get login" do
    get :login
    assert_response :success
  end
  
  test "should get register" do
    get :register
    assert_response :success
  end
  
  test "should create user" do
    assert_difference('User.count') do
      post :create, user: @test_attributes
    end
    assert_redirected_to "/login/login"
  end
  
  
  test "validation should work" do
    user = users(:user1)
    user.validated_at = nil
    user.save
    get :validate, {id: user.id, token: user.validation_token}
    user.reload
    assert user.validated_at, "Validation date not happening"
  end
  
  test "should post authenticate" do
    user = users(:user1)
    post :authenticate, user: {username: user.username, password: 'password'}
    assert_redirected_to '/', "Success should redirect to root"
    post :authenticate, user: {username: 'not-a-valid-username', password: 'not-a-valid-password'}
    assert_redirected_to '/login/login', "Failure should redirect to login"
  end
  
  test "should not accept invalid user" do
    post :authenticate, user: {username: 'not-a-valid-username', password: 'not-a-valid-password'}
    assert_redirected_to "/login/login"
  end

end
