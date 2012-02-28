require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @post = posts(:first)
    @user = users(:david)
    @john = users(:john)
    @post.user = @user
    @post.save
  end
 
  def teardown
    @user = nil
  end

  test "get empty notifications" do
    notifications = @user.all_notifications

    assert_equal 0, notifications[:new_notifications].length
    assert_equal 0, notifications[:old_notifications].length
  end

  test "get new notifications" do
    write_comment(@john, @post)
    write_comment(@john, @post)

    notifications = @user.all_notifications

    assert_equal 2, notifications[:new_notifications].length
    assert_equal 0, notifications[:old_notifications].length
  end

  test "get old notifications" do
    write_comment(@john, @post)
    write_comment(@john, @post)

    # get notifications and mark all new as read
    notifications = @user.all_notifications
    notifications[:new_notifications].update_all(:unread => false)

    # get notifications again
    notifications = @user.all_notifications

    assert_equal 0, notifications[:new_notifications].length
    assert_equal 2, notifications[:old_notifications].length
  end

  private
  def write_comment(user, commentable)
    comment = Comment.new({:text => "Comment Text"})
    comment.user = user
    comment.commentable_id = commentable.id
    comment.commentable_type = commentable.class.name.demodulize
    comment.save
    return comment
  end
 end