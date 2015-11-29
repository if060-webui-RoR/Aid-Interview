require 'test_helper'

class QuestionsEditTest < ActionDispatch::IntegrationTest

  def setup
    @question = questions(:one)
  end

  test 'should show question' do
    get question_path(@question)
    assert_template 'questions/show'
  end

end