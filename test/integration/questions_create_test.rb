require 'test_helper'

class QuestionsInterfaceTest < ActionDispatch::IntegrationTest
  test 'question count' do
    @topic = topics(:one)
    assert_no_difference 'Question.count' do
      post questions_path, question: { topic_id: @topic.id, content: '' }
    end
    assert_select 'div#error_explanation'
    assert_template 'questions/new'

    assert_difference 'Question.count', 1 do
      post questions_path, question: { topic_id: @topic.id, content: 'content' }
    end
  end
end