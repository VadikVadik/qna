require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:url) { 'https://google.com' }
  given(:gist_url) { 'https://gist.github.com/VadikVadik/f72820f93dadf603ec4820c32ca28ddf' }

  describe 'User adds link when asks question' do
    background do
      sign_in(user)
      visit new_question_path

      fill_in 'New question', with: 'Question title'
      fill_in 'Body', with: 'Question body'
    end

    scenario 'with valid url' do
      fill_in 'Link name', with: 'Google'
      fill_in 'Url', with: url

      click_on 'Ask'

      expect(page).to have_link 'Google', href: url
    end

    scenario 'with gist' do
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on 'Ask'

      expect(page).to have_content 'Hello World!'
    end

    scenario 'with invalid url' do
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: 'invalid url'

      click_on 'Ask'

      expect(page).to have_content 'invalid'
    end
  end

  scenario 'User adds multiple links when asks question' do
    sign_in(user)
    visit new_question_path

    fill_in 'New question', with: 'Question title'
    fill_in 'Body', with: 'Question body'

    fill_in 'Link name', with: 'Google'
    fill_in 'Url', with: url

    click_on 'add link'

    fill_in 'Link name', with: 'Google2'
    fill_in 'Url', with: url

    click_on 'Ask'

    expect(page).to have_link 'Google', href: url
    expect(page).to have_link 'Google2', href: url
  end
end
