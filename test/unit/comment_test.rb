require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  fixtures :comments
  test "Presence of required fields" do
    comment = Comment.new
    assert comment.invalid?, "Blank comment not invalid."
    [:user_id, :job_id, :content].each do |k|
      assert comment.errors[k].any?, "No presence validation errors for #{k.to_s}"
    end
  end
  
  test "associations" do
    comment = comments(:one)
    assert comment.user.kind_of?(User), "User association broken"
    assert comment.job.kind_of?(Job), "Job association broken"
  end
end
