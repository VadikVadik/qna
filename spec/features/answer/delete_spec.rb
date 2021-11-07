require 'rails_helper'

feature 'Author can delete created answer', %q{
  In order to manage issues as an author
  I would like to be able to delete the created answer
} do
  given(:author) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, author: author) }
  given!(:answer) { create(:answer, question: question, author: author) }

  scenario 'Author tries to delete created answer', js: true do
    sign_in(author)
    visit question_path(question)

    expect(page).to have_content answer.body

    click_on 'Delete answer'

    expect(page).to_not have_content answer.body
  end

  scenario 'User tries to delete an answer that is chosen the best', js: true do
    sign_in(author)
    visit question_path(question)

    click_on 'Mark as best'
    wait_for_ajax
    click_on 'Delete answer'
    wait_for_ajax

    expect(page).to_not have_content answer.body
  end

  scenario 'User tries to delete an answer created by another user' do
    sign_in(another_user)
    visit question_path(question)

    expect(page).to_not have_link 'Delete answer'
  end

  scenario 'Unauthenticated user tries to delete an answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete answer'
  end
end
