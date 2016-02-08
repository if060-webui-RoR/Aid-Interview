require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = create(:interviewer)
    @not_approved_interviewer = create(:not_approved_interviewer)
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "first_name should be present" do
    @user.last_name = "     "
    assert_not @user.valid?
  end

  test "last_name should be present" do
    @user.last_name = "     "
    assert_not @user.valid?
  end

  test "first_name should not be too long" do
    @user.first_name = "a" * 51
    assert_not @user.valid?
  end

  test "last_name should not be too long" do
    @user.last_name = "a" * 51
    assert_not @user.valid?
  end

  test "should return false for not approved interviewers" do
    assert_not @not_approved_interviewer.approved?
  end

  test "user edit without password" do
    @user = User.first
    new_data = {
      :email => "newmail@gmail.com",
      :first_name => "newname"
    }
    new_data = ActionController::Parameters.new(new_data)
    new_data = new_data.permit(:email, :first_name)
    @user.update_without_password(new_data)

    assert_equal @user.first_name, 'newname', "User is not updated"
  end

  test "user edit with password" do
    @user = User.first
    new_data = {
      :first_name => 'newname',
      :current_password => '123456789'
    }
    new_data = ActionController::Parameters.new(new_data)
    new_data = new_data.permit(:email, :first_name, :last_name, :current_password, :password, :password_confirmation)
    @user.update_with_password(new_data)

    assert_equal @user.first_name, 'newname', 'Password is not
    updated'
  end
end
