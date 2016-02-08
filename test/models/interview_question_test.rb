require 'test_helper'

class InterviewQuestionTest < ActiveSupport::TestCase
  def setup
    @interview_question = create(:interview_question)
  end

  test 'should be valid' do
    assert @interview_question.valid?
  end

  test 'interview_id can not be nil' do
    @interview_question.question_id = nil
    assert_not @interview_question.valid?
  end

  test 'question_id can not be nil' do
    @interview_question.question_id = nil
    assert_not @interview_question.valid?
  end

  test 'comment should not be too long' do
    @interview_question.comment = "a" * 255
    assert @interview_question.valid?
  end

  test 'mark should not be too long' do
    @interview_question.mark = "a" * 256
    assert @interview_question.valid?
  end
end
