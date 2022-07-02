require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  def setup
    ActionMailer::Base.deliveries.clear
  end
  
  test "invalid signup information" do
    get signup_url
    assert_no_difference 'User.count' do
      post users_url, params: {user: { name: "",
                                        email: "user@invalid",
                                        password: "foo",
                                        password_confirmation: "bar" } }
    end
      
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
    
    assert_difference 'User.count', 1 do
    post users_url, params: {user: { name: "Rails Tutorial",
                                      email: "example@railstutorial.org",
                                      password: "exampleuser",
                                      password_confirmation: "exampleuser"} }
    end
    
    follow_redirect!
    # assert_template 'users/show'
    # assert_not flash.blank?
    # assert_select 'div.alert-success'と同じ（flashが存在するか）　これは成功時のクラス名指定
  end
  
  test 'valid signup information with account activation' do
    get signup_path
    assert_difference 'User.count', 1 do
    post users_path, params: { user: {  name: "Rails Tutorial",
                                        email: "example@railstutorial.org",
                                        password: "password",
                                        password_confirmation: "password" } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    #有効かしてない状態でのログイン
    log_in_as(user)
    assert_not is_logged_in?
    #有効でないトークンでの有効リンクをアクセス
    get edit_account_activation_path("Invalid token", email: user.email) 
    assert_not is_logged_in?
    # 有効なトークンだが、メールアドレスが無効な場合
    get edit_account_activation_path(user.activation_token, email: "wrong email address")
    assert_not is_logged_in?
    # 有効な正しいトークン、メールアドレスの場合
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
  
end
