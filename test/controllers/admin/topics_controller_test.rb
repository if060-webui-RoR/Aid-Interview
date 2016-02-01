require 'test_helper'

module Admin
  class TopicsControllerTest < ActionController::TestCase
    def setup
      @topic = create(:topic)
      @question = create(:question)
      @admin = create(:admin)
      sign_in @admin
    end

    test 'should update topic' do
      patch :update, id: @topic.id, topic: { title: 'Some title' }
      assert_not_nil flash[:success] = 'Topic updated'
    end

    test 'should destroy topic' do
      if @topic.questions.empty?
        assert_difference 'Topic.count', -1 do
          delete :destroy, id: @topic.id
        end
        assert_not_nil flash[:success] = 'Topic deleted'
      end
    end
  end
end
