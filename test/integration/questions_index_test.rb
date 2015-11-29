require 'test_helper'

class QuestionsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @question = questions(:one)
  end


  test 'index including ' do
    get questions_path
    assert_template 'questions/index'
    assert_select 'a[href=?]', question_path(@question), text: 'Show'
    assert_select 'a[href=?]', edit_question_path(@question), text: 'Edit'
    assert_select 'a[href=?]', new_question_path, text: 'Create new question'
    assert_select 'a[href=?]', question_path(@question), text: 'Destroy'

    assert_difference 'Question.count', -1 do
      delete question_path(@question)
    end
  end

end
