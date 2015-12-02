require 'test_helper'

class QuestionsEditTest < ActionDispatch::IntegrationTest
  def setup
    @topic    = topics(:one)
    @question = questions(:one)
  end

  test 'unsuccessful edit' do
    get edit_admin_question_path(@question)
    assert_template 'questions/edit'
    patch admin_question_path(@question), question: { topic_id: @topic.id, content: '' }
    assert_not_nil flash[:danger]
    assert_template 'questions/edit'
  end

  test 'successful edit' do
    get edit_admin_question_path(@question)
    assert_template 'questions/edit'
    content = 'Example'
    patch admin_question_path(@question), question: { topic_id: @topic.id, content: content }
    assert_not_nil flash[:success]
    assert_redirected_to @question
    @question.reload
    assert_equal content,  @question.content
  end

end
