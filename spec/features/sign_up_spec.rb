require 'rails_helper'

feature 'Guest can sign up in system', %q{
  In order to ask questions and give answers to other users
  I would like to be able to register in the system
} do
  background { visit new_user_registration_path }

  scenario 'Guest tries sign up' do
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'Guest tries sign up wuth errors' do
    click_on 'Sign up'

    expect(page).to have_content "Email can't be blank"
  end
end
