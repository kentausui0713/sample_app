require 'test_helper'

class UserLoginTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end
  
  test 'login with valid information followed by logout' do
    get login_path
    post login_path, params: { session: { email: @user.email,
                               password: 'password' } }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    # assert_select "a[href=?]", login_path, count: 0
    # assert_select "a[href=?]", logout_path
    # assert_select "a[href=?]", user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_path
    # 2番目のウィンドウでログアウトをクリックするシミュレート
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
  
  test 'login with valid email/invalid passwod' do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: @user.email,
                                          password: 'invalidpassword' } }
    assert_not is_logged_in?
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
  
  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "", passowrd: "" } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
  
  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_equal cookies['remember_token'], assigns(:user).remember_token
  end
  
  test "login without remembering" do
    #cookieを保存してログイン(remember_meチェックボックスを入れた状態でログイン)
    log_in_as(@user, remember_me: '1')
    delete logout_path
    #cookieを保存せずにログイン(remember_meチェックボックスを入れずログイン)
    log_in_as(@user, remember_me: '0')
    assert_empty cookies[:remember_token]
  end
  
end
