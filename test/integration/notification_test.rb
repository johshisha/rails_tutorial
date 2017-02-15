require 'test_helper'

class NotificationTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:johshisha)
    log_in_as(@user)
  end
  
  test "notifications page" do
    get notifications_user_path(@user)
    assert_not @user.notification.empty?
    @user.notification.each do |micropost|
      assert_match micropost.content, response.body
    end
  end
end
