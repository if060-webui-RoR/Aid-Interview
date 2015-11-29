require 'test_helper'

class TemplateTest < ActiveSupport::TestCase
  def setup
    @template = Template.new(name: 'Example')
  end

  test 'should be valid' do
    assert @template.valid?
  end

  test 'can not be blank' do
    @template.name = ' '
    assert_not @template.valid?
  end

  test "content should be unique" do
    duplicate_template = @template.dup
    @template.save
    assert_not duplicate_template.valid?
  end
end
