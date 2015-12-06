require 'test_helper'

class TemplateCreateTest < ActionDispatch::IntegrationTest
  def setup
    @template = templates(:one)
    @question = questions(:three)
  end

  test 'template count' do
    assert_no_difference 'Template.count' do
      post admin_templates_path, template: { name: '' }
    end
    assert_template 'templates/new'

    assert_difference 'Template.count', 1 do
      post admin_templates_path, template: { name: 'content' }
    end
  end
end
