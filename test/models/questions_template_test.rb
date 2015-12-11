require 'test_helper'

class QuestionsTemplateTest < ActiveSupport::TestCase
  def setup
    @template = templates(:one)
    @question = questions(:three)
    @questions_template = @template.questions_templates.build(question: @question)
  end

  test 'should be valid' do
    assert @questions_template.valid?
  end

  test 'should require a template_id' do
    @questions_template.template_id = nil
    assert_not @questions_template.valid?
  end

  test 'should require a question_id' do
    @questions_template.question_id = nil
    assert_not @questions_template.valid?
  end

  test 'should not allow the same question in template 2 times' do
    duplicate_questions_template = @questions_template.dup
    assert duplicate_questions_template.valid?
    @questions_template.save
    assert_not duplicate_questions_template.valid?
  end
end
