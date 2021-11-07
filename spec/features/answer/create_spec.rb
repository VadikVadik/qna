require 'rails_helper'

feature 'User can create answer', %q{
  In order to give answer to the question
  As an authenticated user
  I'd like to be able to answer questions
  Being on the question page
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'tries to give answer', js: true do
      fill_in 'Your answer', with: 'new answer body'
      click_on 'Create'

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'new answer body'
      end
    end

    scenario 'tries to give answer with errors', js: true do
      click_on 'Create'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to give answer' do
    visit question_path(question)

    fill_in 'Your answer', with: 'new answer body'
    click_on 'Create'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
