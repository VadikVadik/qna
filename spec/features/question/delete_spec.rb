require 'rails_helper'

feature 'Author can delete created question', %q{
  In order to manage issues as an author
  I would like to be able to delete the created question
} do
  given(:users) { create_list(:user, 2) }
  given(:question) { create(:question, author: users[0]) }

  scenario 'Author tries to delete created question' do
    sign_in(users[0])
    visit question_path(question)
    click_on 'Delete question'

    expect(page).to have_content 'Question was successfully deleted'
  end

  scenario 'User tries to delete a question created by another user' do
    sign_in(users[1])
    visit question_path(question)

    expect(page).to_not have_content 'Delete question'
  end
end
