require 'test_helper'

module Admin
  class QuestionsControllerTest < ActionController::TestCase
    def setup
      @topic = create(:topic)
      @question = create(:question)
      sign_in create(:admin)
      @request.env["HTTP_REFERER"] = "http://test.hostadmin/admin/questions"
    end

    test 'should get question index by admin' do
      get :index
      assert_response :success
    end

    test "should not create question by interviewer" do
      sign_in create(:interviewer)
      get :new
      assert_response :redirect
    end

    test 'should get question show by admin' do
      assert_routing 'admin/questions/200', controller: "admin/questions", action: "show", id: "200"
      assert_no_difference 'Question.count' do
        get :index, id: @question.id
        assert_response :success
      end
    end

    test 'should not get question show by interviewer' do
      sign_in create(:interviewer)
      assert_no_difference 'Question.count' do
        get :show, id: @question.id
        assert_response :redirect
      end
    end

    test 'should not get question index by interviewer' do
      sign_in create(:interviewer)
      get :index
      assert_response :redirect
    end

    test 'should not get question edit by interviewer' do
      sign_in create(:interviewer)
      get :edit, id: @question.id
      assert_response :redirect
    end

    test 'should not get question update by interviewer' do
      sign_in create(:interviewer)
      get :update, id: @question.id
      assert_response :redirect
    end

    test 'should destroy question by admin' do
      assert_difference 'Question.count', -1 do
        delete :destroy, id: @question.id
      end
    end

    test 'should not destroy question by interviewer' do
      sign_in create(:interviewer)
      get :destroy, id: @question.id
      assert_response :redirect
    end
  end
end
