require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
  def setup
    @topic = Topic.first
    @question = Question.new(topic: @topic, content: 'Example')
  end

  test 'should be valid' do
    assert @question.valid?
  end

  test 'content can not be blank' do
    @question.content = ' '
    assert_not @question.valid?
  end

  test 'topic can not be empty' do
    @question.topic = nil
    assert_not @question.valid?
  end

  test 'content should be unique' do
    duplicate_question = @question.dup
    @question.save
    assert_not duplicate_question.valid?
  end

end
