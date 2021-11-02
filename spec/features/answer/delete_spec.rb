require 'rails_helper'

feature 'Author can delete created answer', %q{
  In order to manage issues as an author
  I would like to be able to delete the created answer
} do
  given(:users) { create_list(:user, 2) }
  given(:question) { create(:question, author: users[0]) }
  given!(:answer) { create(:answer, question: question, author: users[0]) }

  scenario 'Author tries to delete created answer' do
    sign_in(users[0])
    visit question_path(question)
    click_on 'Delete answer'

    expect(page).to have_content 'Answer was successfully deleted'
  end

  scenario 'User tries to delete an answer created by another user' do
    sign_in(users[1])
    visit question_path(question)

    expect(page).to_not have_content 'Delete answer'
  end
end
