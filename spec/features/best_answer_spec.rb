require 'rails_helper'

feature 'User can choose the best answer for a question', %q{
  In order for users to get the best solution
  As an author of question
  I'd like to be able to choose the best answer
} do
  given!(:user) { create(:user) }
  given!(:another_user) {create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:first_answer) { create(:answer, question: question, author: user) }
  given!(:second_answer) { create(:answer, question: question, author: user) }

  scenario 'Unauthenticated can not choose the best answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Mark as best'
  end
  describe 'Authenticated user' do
    context 'for his question' do
      before do
        sign_in(user)
        visit question_path(question)

        find('.answers li:first-child .best-link').click()
        wait_for_ajax
      end

      scenario 'choose the best answer', js: true do
        within('.best-answer') do
          expect(page).to have_content first_answer.body
        end
      end
      scenario 'change the best answer', js: true do
        within('.best-answer') do
          expect(page).to have_content first_answer.body
        end

        find('.answers li:last-child .best-link').click()
        wait_for_ajax

        within('.best-answer') do
          expect(page).to have_content second_answer.body
        end
      end
    end
    scenario 'tries to choose the best answer for another user question' do
      sign_in(another_user)
      visit question_path(question)

      expect(page).to_not have_link 'Mark as best'
    end
  end
end
