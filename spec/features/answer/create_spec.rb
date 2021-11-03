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

    scenario 'tries to give answer' do
      fill_in 'Answer', with: 'new answer body'
      click_on 'To answer'

      expect(page).to have_content question.title
      expect(page).to have_content question.body
      expect(page).to have_content 'new answer body'
    end

    scenario 'tries to give answer with errors' do
      click_on 'To answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to give answer' do
    visit question_path(question)

    fill_in 'Answer', with: 'new answer body'
    click_on 'To answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
