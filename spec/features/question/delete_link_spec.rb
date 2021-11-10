require 'rails_helper'

feature 'User can delete links from question', %q{
  In order to correct list of my question links
  As an question's author
  I'd like to be able to delete links
} do
  given!(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:link) { create(:link, linkable: question) }

  scenario 'Authenticated user delete link from his question', js: true do
    sign_in(user)
    visit question_path(question)

    within '.question' do
      click_on 'Delete link'
      expect(page).to_not have_link link.name, href: link.url
    end
  end

  scenario 'Authenticated user tries delete link from question of another user' do
    sign_in(another_user)
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'Delete link'
    end
  end

  scenario 'Unauthenticated user tries delete link from question' do
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'Delete link'
    end
  end
end
