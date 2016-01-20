require 'test_helper'

class InterviewQuestionsControllerTest < ActionController::TestCase
  def setup
    @interview = create(:interview)
    @interview_question = create(:interview_question)
    sign_in create(:interviewer)
  end

  test "should redirect edit for admin" do
    sign_in create(:admin)
    get :edit, id: @interview_question, interview_id: @interview
    assert_response :redirect
  end

  test "should redirect edit for not approved interviewer" do
    sign_in create(:not_approved_interviewer)
    get :edit, id: @interview_question, interview_id: @interview
    assert_redirected_to user_session_path
  end

  test "should not get interview_question update by admin" do
    sign_in create(:admin)
    patch :update, id: @interview_question, interview_id: @interview
    assert_response :redirect
  end

  test "should not get interview_question update by not_approved_interviewer" do
    sign_in create(:not_approved_interviewer)
    patch :update, id: @interview_question, interview_id: @interview
    assert_response :redirect
  end
end
