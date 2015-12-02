require 'test_helper'

class QuestionstemplateTest < ActiveSupport::TestCase
  def setup
    @template = templates(:one)
    @question = questions(:three)
    @questionstemplate = @template.questionstemplates.build(question: @question)
  end

  test 'should be valid' do
    assert @questionstemplate.valid?
  end

  test 'should require a template_id' do
    @questionstemplate.template_id = nil
    assert_not @questionstemplate.valid?
  end

  test 'should require a question_id' do
    @questionstemplate.question_id = nil
    assert_not @questionstemplate.valid?
  end

  test 'should not allow the same question in template 2 times' do
    duplicate_questionstemplate = @questionstemplate.dup
    assert duplicate_questionstemplate.valid?
    @questionstemplate.save
    assert_not duplicate_questionstemplate.valid?
  end
end
