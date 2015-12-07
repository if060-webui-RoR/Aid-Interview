require 'test_helper'

class QuestionsShowTest < ActionDispatch::IntegrationTest
  def setup
    @question = questions(:one)
  end

  test 'should show question' do
    get admin_question_path(@question)
    assert_template 'questions/show'
  end

end