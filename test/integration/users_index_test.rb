require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin = users(:michael)
    @non_admin = users(:archer)
  end
  
  test "index as admin including pagenation and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select "div.pagination"
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select "a[href=?]", user_path(user), text: user.name
      unless user == @admin
        assert_select "a[href=?]", user_path(user), text: "delete"
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end
  
  test "index as non_admin" do
    log_in_as(@non_admin)
    # non_adminでユーザーを消せないことをテスト
    # (演習でbefore_action :admin_userをコメにしてもredにならなかったので修正)
    assert_no_difference 'User.count' do
      delete user_path(@admin)
    end
    assert_redirected_to root_path
    # non_adminで〜〜　ここまで
    get users_path
    assert_select "a", text: "delete", count: 0
  end
  
end
