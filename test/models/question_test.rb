require 'test_helper'

class QuestionTest < ActiveSupport::TestCase

  def setup
    @topic = topics(:one)
    @question = Question.new(topic: @topic, content: 'Example')
  end

  test 'should be valid' do
    assert @question.valid?
  end

  test 'can not be blank' do
    @question.content = ' '
    assert_not @question.valid?
  end

  test "content should be unique" do
    duplicate_question = @question.dup
    @question.save
    assert_not duplicate_question.valid?
  end

  test 'topic id should be present' do
    @question.topic_id = nil
    assert_not @question.valid?
  end
end
