require 'test_helper'

class JobTest < ActiveSupport::TestCase
  fixtures :jobs
  
  test "Presence of required fields" do
    job = Job.new
    assert job.invalid?, "Blank job not invalid."
    [:title, :company, :description, :user_id].each do |k|
      assert job.errors[k].any?, "No presence validation errors for #{k.to_s}"
    end
  end
  
  test "Associations" do
    job = jobs(:job1)
    assert job.user.kind_of?(User), "Job does not have a valid user."
  end
end
