require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: {user: { name: "",
                                        email: "user@invalid",
                                        password: "foo",
                                        password_confirmation: "bar" } }
    end
      
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
    
    assert_difference 'User.count', 1 do
    post users_path, params: {user: { name: "Rails Tutorial",
                                      email: "example@railstutorial.org",
                                      password: "exampleuser",
                                      password_confirmation: "exampleuser"} }
    end
    
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.blank?
    # assert_select 'div.alert-success'と同じ（flashが存在するか）　これは成功時のクラス名指定
  end
  
  test 'valid signup information' do
    get signup_path
    assert_difference 'User.count', 1 do
    post users_path, params: { user: {  name: "Rails Tutorial",
                                        email: "example@railstutorial.org",
                                        password: "password",
                                        password_confirmation: "password" } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
  
end
