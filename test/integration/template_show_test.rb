require 'test_helper'

class TemplateShowTest < ActionDispatch::IntegrationTest
  def setup
    @template = templates(:one)
    @question = questions(:three)
    @questionsTemplate = questions_templates(:one)
  end

  test 'questions in template count' do

    assert_difference 'QuestionsTemplate.count', 1 do
      post admin_questionstemplates_path, template_id: @template.id,
                                    questions_template: { question_id: @question.id }
    end

    assert_difference 'Questionstemplate.count', -1 do
      delete admin_questionstemplate_path(@questions_template)
    end
  end
end
