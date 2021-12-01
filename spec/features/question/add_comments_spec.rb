require 'rails_helper'

feature 'User can add comments to question', %q{
  In order to comment questions
  As an authenticated user
  I'd like to be able to add comments
} do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, author: author) }

  describe 'User comments question' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'with valid body', js: true do
      within('.question-comments-container') do
        fill_in 'Body', with: 'Question comment'

        click_on 'Comment'
      end

      expect(page).to have_content 'Question comment'
    end

    scenario 'with invalid body', js: true do
      within('.question-comments-container') do
        click_on 'Comment'
      end

      expect(page).to_not have_content 'Question comment'
      expect(page).to have_content "Body can't be blank"
    end
  end

  describe 'multiple sessions' do
    scenario "comment appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within('.question-comments-container') do
          fill_in 'Body', with: 'Question comment'

          click_on 'Comment'
        end
        wait_for_ajax

        expect(page).to have_content 'Question comment'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Question comment'
      end
    end
  end
end
