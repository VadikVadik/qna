require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like to be able to ediy my question
} do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:url) { 'https://google.com' }

  scenario 'Unauthenticated can not edit question' do
    visit(question_path(question))

    expect(page).to_not have_link 'Edit question'
  end

  describe 'Authenticated user' do
    context 'edits his question' do
      before do
        sign_in(user)
        visit question_path(question)

        click_on 'Edit question'
      end

      scenario 'with valid attributes', js: true do
        fill_in 'New question', with: 'Edited question'
        click_on 'Save'
        wait_for_ajax

        within '.question' do
          expect(page).to_not have_content question.body
          expect(page).to have_content 'Edited question'
          expect(page).to_not have_selector 'textarea'
        end
      end

      scenario 'with attached files', js: true do
        within '.question' do
          attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Save'
          wait_for_ajax

          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end

      scenario 'with the addition of a link', js: true do
        within '.question' do
          click_on 'add link'

          fill_in 'Link name', with: 'Google'
          fill_in 'Url', with: url

          click_on 'Save'
          wait_for_ajax

          expect(page).to have_link 'Google', href: url
        end
      end

      scenario 'with file deletion', js: true do
        within '.question' do
          attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
          click_on 'Save'
          wait_for_ajax

          expect(page).to have_link 'rails_helper.rb'

          click_on 'Delete file'
          wait_for_ajax

          expect(page).to_not have_link 'rails_helper.rb'
        end
      end

      scenario 'with errors', js: true do
        fill_in 'New question', with: ''
        click_on 'Save'
        wait_for_ajax

        expect(page).to have_content question.body
        expect(page).to have_content "Body can't be blank"
        expect(page).to have_selector 'textarea'
      end
    end

    scenario "tries to edit other user's question" do
      sign_in(another_user)
      visit question_path(question)

      expect(page).to_not have_link 'Edit question'
    end
  end
end
