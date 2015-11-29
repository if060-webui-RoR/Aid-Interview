require 'test_helper'

class QuestionsEditTest < ActionDispatch::IntegrationTest
  def setup
    @topic    = topics(:one)
    @question = questions(:one)
  end

  test 'unsuccessfull edit' do
    get edit_question_path(@question)
    assert_template 'questions/edit'
    patch question_path(@question), question: { topic_id: @topic.id, content: '' }
    assert_template 'questions/edit'
    assert_select 'div#error_explanation'
  end

  test 'successfull edit' do
    get edit_question_path(@question)
    assert_template 'questions/edit'
    content = 'Example'
    patch question_path(@question), question: { topic_id: @topic.id, content: content }
    assert_redirected_to @question
    @question.reload
    assert_equal content,  @question.content
  end

end
