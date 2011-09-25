require 'test_helper'

class InboxControllerTest < ActionController::TestCase
  fixtures :comments
  setup do
    @comment = comments(:one)
  end
  
  test "Should get index" do
    get :index, {id: 2}, {user_id: @comment.user_id}
    assert_response :success
  end
  
  test "Should get view" do
    get :view, {id: @comment.id}, {user_id: @comment.user_id}
    assert_response :success
  end
  
  test "Should delete message" do
    assert_difference('Comment.count', -1) do
      delete :delete, {id: @comment.id}, {user_id: @comment.user_id}
    end
  end
end
