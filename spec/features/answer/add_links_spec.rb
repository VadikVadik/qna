require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:gist_url) { 'https://gist.github.com/VadikVadik/f72820f93dadf603ec4820c32ca28ddf' }

  describe 'User adds link when answers the question' do
    background do
      sign_in(user)
      visit question_path(question)

      fill_in 'Your answer', with: 'new answer body'
    end

    scenario 'with valid url', js: true do
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on 'Create'

      within '.answers' do
        expect(page).to have_link 'My gist', href: gist_url
      end
    end

    scenario 'with invalid url', js: true do
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: 'invalid url'

      click_on 'Create'

      within '.answers' do
        expect(page).to_not have_link 'My gist', href: gist_url
      end

      expect(page).to have_content 'invalid'
    end
  end

  scenario 'User adds multiple links when answers the question', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Your answer', with: 'new answer body'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'add link'

    fill_in 'Link name', currently_with: '', with: 'My gist2'
    fill_in 'Url', currently_with: '', with: gist_url

    click_on 'Create'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
      expect(page).to have_link 'My gist2', href: gist_url
    end
  end
end
