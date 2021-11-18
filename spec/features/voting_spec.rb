require 'rails_helper'

feature 'Users can vote for questions and answers', %q{
  To form a rating of a question or answer,
  As authenticated user,
  I want to be able to cast my vote "for" or "against" it
} do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:answer) { create(:answer, question: question, author: user) }

  describe 'Authenticated user' do
    background do
      sign_in(another_user)
      visit question_path(question)
    end

    scenario 'tries to vote for the question', js: true do
      within('.question') do
        click_on 'Vote for'
        expect(page).to have_content 'Rating: 1'
      end
    end

    scenario 'tries to vote against the question', js: true do
      within('.question') do
        click_on 'Vote against'
        expect(page).to have_content 'Rating: -1'
      end
    end

    scenario 'tries to change vote', js: true do
      within('.question') do
        click_on 'Vote against'
        expect(page).to have_content 'Rating: -1'

        click_on 'Change my vote'

        click_on 'Vote for'
        expect(page).to have_content 'Rating: 1'
      end
    end
  end

  scenario 'Authenticated user tries to vote for the his question' do
    sign_in(user)
    visit question_path(question)

    expect(page).to_not have_link 'Vote for'
  end

  describe 'Unauthenticated user' do
    background do
      visit question_path(question)
    end

    scenario 'tries to vote for the question', js: true do
      within('.question') do
        click_on 'Vote for'
        expect(page).to have_content 'You need to sign in or sign up before continuing.'
      end
    end
  end
end
