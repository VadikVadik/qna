require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to ediy my answer
} do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }

  scenario 'Unauthenticated can not edit answer' do
    visit(question_path(question))

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    context 'edits his answer' do
      before do
        sign_in(user)
        visit question_path(question)

        click_on 'Edit'
      end

      scenario 'with valid attributes', js: true do
        within '.answers' do
          fill_in 'New answer', with: 'Edited answer'
          click_on 'Save'
          wait_for_ajax

          expect(page).to_not have_content answer.body
          expect(page).to have_content 'Edited answer'
          expect(page).to_not have_selector 'textarea'
        end
      end

      scenario 'with errors', js: true do
        within '.answers' do
          fill_in 'New answer', with: ''
          click_on 'Save'
          wait_for_ajax

          expect(page).to have_content answer.body
          expect(page).to have_content "Body can't be blank"
          expect(page).to have_selector 'textarea'
        end
      end
    end

    scenario "tries to edit other user's answer" do
      sign_in(another_user)
      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_link 'Edit'
      end
    end
  end
end
