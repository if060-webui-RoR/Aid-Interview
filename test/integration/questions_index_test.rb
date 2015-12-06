require 'test_helper'

class QuestionsIndexTest < ActionDispatch::IntegrationTest
  def setup
    @question = questions(:three)
  end


  test 'index including ' do
    get admin_questions_path
    assert_template 'questions/index'
    assert_select 'a[href=?]', admin_question_path(@question), text: 'Show'
    assert_select 'a[href=?]', edit_admin_question_path(@question), text: 'Edit'
    assert_select 'a[href=?]', new_admin_question_path, text: 'Create new question'
    assert_select 'a[href=?]', admin_question_path(@question), text: 'Destroy'

    assert_difference 'Question.count', -1 do
      delete admin_question_path(@question)
    end
  end

end
