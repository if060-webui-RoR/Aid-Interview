require 'rails_helper'

feature 'angular test' do
  let(:first_name) { 'Bob' }
  let(:last_name)  { 'Jones' }
  let(:email)      { 'bob@example.com' }
  let(:password)   { 'password123' }
  let(:approved)   { true }

  before do
    User.create!(first_name: first_name,
                 last_name:  last_name,
                 email: email,
                 password: password,
                 password_confirmation: password,
                 approved: approved)
  end

  scenario 'Our Angular Test App is Working' do
    visit 'users/sign_in'

    # Log In
    fill_in 'Email', with: 'bob@example.com'
    fill_in 'Password', with: 'password123'
    click_button 'Log in'

    expect(page).to have_content('Welcome ' + ' ' + first_name + ' ' + last_name)

    visit '/templates'

    expect(page).to have_content('Create new template')

    visit 'templates#/new'

    expect(page).to have_content('Add a new Template')

    fill_in 'Enter templates name', with: 'Bob'
    expect(page).to have_content('Add a new Template')
  end
end
