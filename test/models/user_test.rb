require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
            userid: "example",
            password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "   "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "   "
    assert_not @user.valid?
  end
  
  test "userid should be present" do
    @user.userid = "   "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end
  
  test "userid should not be too log" do
    @user.userid = "a"*19
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                    first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do | valid_address |
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                         foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
  
  test "userid should be unique" do
    duplicate_user = @user.dup
    duplicate_user.userid = @user.userid.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end

  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference "Micropost.count", -1 do
      @user.destroy
    end
  end

  test "should follow and unfollow a user" do
    johshisha = users(:johshisha)
    archer = users(:archer)
    assert_not johshisha.following?(archer)
    johshisha.follow(archer)
    assert johshisha.following?(archer)
    assert archer.followers.include?(johshisha)
    johshisha.unfollow(archer)
    assert_not johshisha.following?(archer)
  end

  test "feed should have the right posts" do
    johshisha = users(:johshisha)
    archer = users(:archer)
    lana = users(:lana)
    # feed following user's posts
    lana.microposts.each do |post_following|
      assert johshisha.feed.include?(post_following)
    end
    # feed own posts
    johshisha.microposts.each do |post_self|
      assert johshisha.feed.include?(post_self)
    end
    # don't feed unfollowing user's posts
    archer.microposts.each do |post_unfollowing|
      assert_not johshisha.feed.include?(post_unfollowing)
    end
  end
  
  test "notification should have right posts" do
    johshisha = users(:johshisha)
    @user.save
    # notifications
    assert_difference "johshisha.notification.count", 2 do
      @user.microposts.create!(content: "@johshisha Hi!")
      @user.microposts.create!(content: "Hey @johshisha")
    end
  end
end
