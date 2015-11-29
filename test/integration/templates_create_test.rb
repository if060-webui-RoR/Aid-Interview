require 'test_helper'

class TemplatesCreateTest < ActionDispatch::IntegrationTest

  test 'template count' do
    assert_no_difference 'Template.count' do
      post templates_path, template: { name: '' }
    end
    assert_select 'div#error_explanation'
    assert_template 'templates/new'

    assert_difference 'Template.count', 1 do
      post templates_path, template: { name: 'content' }
    end
  end
end
