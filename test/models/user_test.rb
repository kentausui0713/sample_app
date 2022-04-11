require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def set up
    @user = User.new(name: "ExampleUser", email: "example@example.com")
  end
  
  def "should be valid" do
    assert @user.valid?
  end
end
