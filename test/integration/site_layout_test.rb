require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:johshisha)
  end
  
  test "layout links without login" do
    get root_path
    assert_template 'static_pages/home'
    
    # header
    assert_select "a[href=?]", root_path, count:2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", login_path
    
    # footer
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
  end
  
  test "layout links with login" do
    log_in_as(@user)
    get root_path
    assert_template 'static_pages/home'
    
    # header
    assert_select "a[href=?]", root_path, count:2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", users_path
    
    # account tab
    assert_select "a[href=?]", user_path(@user)
    assert_select "a[href=?]", notifications_user_path(@user)
    assert_select "a[href=?]", edit_user_path(@user)
    assert_select "a[href=?]", logout_path
    
    # footer
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
  end
    

end
