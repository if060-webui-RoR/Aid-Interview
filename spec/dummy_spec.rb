require 'rails_helper.rb'

describe 'testing that rspec is configured' do
  it 'should pass' do
    expect(1 + 1).to eq(2)
  end
  it 'can fail' do
    expect(1 + 2).to eq(3)
  end
end
