require 'test_helper'

class JobsControllerTest < ActionController::TestCase
  fixtures :jobs

  setup do
    @job = jobs(:job1)
    @user = @job.user
  end

  test "should get index" do
    get :index
    assert_response :success
  end
  
  test "should get edit when logged in" do
    get :edit, {id: @job.id}, {user_id: @user.id}
    assert_response :success
    get :edit, {id: @job.id}, {user_id: nil}
    assert_redirected_to '/', "No user id should fail and redirect"
  end
  
  test "should get new when logged in" do
    get :new, {}, {user_id: @user.id}
    assert_response :success
    get :new, {}, {user_id: nil}
    assert_response :redirect, "Should redirect on no user id" 
  end
  
  test "should create job when logged in" do
    assert_difference('Job.count') do
      post :create, {job: @job.attributes}, {user_id: @user.id}
    end
    assert_difference('Job.count', 0) do 
      post :create, {job: @job.attributes}, {user_id: nil}
    end
  end

  test "should update job when logged in" do
    put :update, {id: @job.to_param, job: @job.attributes}, {user_id: @user.id}
    assert_redirected_to job_path(assigns(:job))
    put :update, {id: @job.to_param, job: @job.attributes}, {user_id: (@user.id + 1)}
  end
  
  test "should destroy job when logged in" do
    assert_difference('Job.count', -1) do
      delete :destroy, {id: @job.to_param}, {user_id: @job.user_id}
    end
    assert_redirected_to jobs_path
  end
end
