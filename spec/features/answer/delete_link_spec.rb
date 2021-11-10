require 'rails_helper'

feature 'User can delete links from answer', %q{
  In order to correct list of my answer links
  As an answwer's author
  I'd like to be able to delete links
} do
  given!(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, author: user, question: question) }
  given!(:link) { create(:link, linkable: answer) }

  scenario 'Authenticated user delete link from his answer', js: true do
    sign_in(user)
    visit question_path(question)

    within '.answers' do
      click_on 'Delete link'
      expect(page).to_not have_link link.name, href: link.url
    end
  end

  scenario 'Authenticated user tries delete link from answer of another user' do
    sign_in(another_user)
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Delete link'
    end
  end

  scenario 'Unauthenticated user tries delete link from answer' do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Delete link'
    end
  end
end
