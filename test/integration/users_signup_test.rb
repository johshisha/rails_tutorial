require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  def setup
    ActionMailer::Base.deliveries.clear
  end
  
  test "invalid signup information" do
    get signup_path
    assert_no_difference "User.count" do
      post users_path, user: { name: "",
                email: "user@invalid",
                userid: "  ",
                password: "foo",
                password_confirmation: "bar" }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert-danger'
 end

  test "valid signup information with account activation" do
    get signup_path
    assert_difference "User.count" do
      post users_path, params: { 
                        user: { name: "Rails Tutorial",
                                email: "example@railstutorial.org",
                                userid: "example",
                                password: "tutorial",
                                password_confirmation: "tutorial" 
                              } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size # 配信されたメールが一つだったかどうか
    user = assigns(:user) # 対応するアクションのインスタンス変数にアクセスできるように
    assert_not user.activated?
    # login without activation
    log_in_as(user)
    assert_not is_logged_in?
    # case of invalid activation token
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?
    # activate with incorrect email and correct token
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # activate with valid token
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
    assert_not flash.empty?
  end

end
