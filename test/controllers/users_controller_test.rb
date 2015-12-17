require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  test "should get show for admin" do
    sign_in create(:admin)
    get :show
    assert_response :success
    assert_select "h2", 'Admin dashboard'
  end

  test "should get show for interviewer" do
    sign_in create(:interviewer)
    get :show
    assert_response :success
    assert_select "p",'You are interviewer'
  end

  test "should redirect show for not approved interviewer" do
    sign_in create(:not_approved_interviewer)
    get :show
    assert_redirected_to user_session_path
  end

  test "should redirect show for not logged in users" do
    get :show
    assert_redirected_to user_session_path
  end

end
