require 'rails_helper'

feature 'Author can delete created question', %q{
  In order to manage issues as an author
  I would like to be able to delete the created question
} do
  given(:author) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, author: author) }

  scenario 'Author tries to delete created question' do
    sign_in(author)
    visit question_path(question)
    expect(page).to have_content question.title
    expect(page).to have_content question.body

    click_on 'Delete question'

    expect(page).to have_content 'Question was successfully deleted'
    expect(page).to_not have_content question.title
  end

  scenario 'User tries to delete a question created by another user' do
    sign_in(another_user)
    visit question_path(question)

    expect(page).to_not have_link 'Delete question'
  end

  scenario 'Unauthenticated user tries to delete a question' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete question'
  end
end
