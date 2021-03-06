require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end
  
  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: {  name: "",
                                                email: "foobar@invalid",
                                                password: "foo",
                                                password_confirmation: "bar"
                                    } }
    assert_template 'users/edit'
  end
  
  test "successful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name: name,
                                              email: email,
                                              password: "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
  
  test "should redirect edit when no logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_path
  end
  
  test "should redirect update when no logged in" do
    patch user_path(@user), params: { user: {  name: "oooooooo",
                                              email: "eeeeee@foo.com" } }
    assert_not flash.empty?
    assert_redirected_to login_path
  end
  
  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to root_path
  end
  
  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch user_path(@user), params:{  user:{  name: @user.name,
                                              email: @user.email  }}
    assert_not flash.empty?
    assert_redirected_to root_path
  end
  
  test "successful edit with friendly fowarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name: name,
                                              email: email  }}
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
  
  # 10.33????????????1??????????????????????????????
  test "should nothing forwording_url as second login" do
    get edit_user_path(@user)
    log_in_as(@user)
    delete logout_path(@user)
    get login_path
    assert session[:forwording_url].nil?
    post login_path, params:{ session: { email: @user.email,
                                         password: 'password'  } }
    assert_redirected_to @user
  end
  
end
