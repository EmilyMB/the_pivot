require "test_helper"

class UserAuthorizationTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  attr_reader :user

  def setup
    @user = User.create(username: "user",
                        password: "password",
                        first_name: "John",
                        last_name: "Doe",
                        email: "example@example.com"
                        )
                        visit root_url
  end

  test "an unauthorized user cannot see another user's order history and
        only his own" do
    user = create(:user)
    user1 = create(:user)
    ApplicationController.any_instance.stubs(:current_user).returns(user)

    visit "/users/#{user1.id}/orders"
    assert_equal root_url, current_path

    visit "/users/#{user.id}/orders"
    assert page.has_content?("Order History")
  end
end
