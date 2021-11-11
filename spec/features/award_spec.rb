require 'rails_helper'

feature 'The author of the question can assign a reward for the best answer', %q{
  In order to encourage the author of the best answer to the question,
  As an author of the question,
  I'd like to be able to assign a reward for the best answer
} do
  given(:user) { create(:user) }

  scenario 'when creating a question, the user can assign a reward', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'New question', with: 'Question title'
    fill_in 'Body', with: 'Question body'

    click_on 'add award'

    fill_in 'Award title', with: 'Gold award'

    click_on 'Ask'

    expect(page).to have_content 'GOLD AWARD'
  end

  scenario 'when choosing the best answer, its author will receive an award', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'New question', with: 'Question title'
    fill_in 'Body', with: 'Question body'

    click_on 'add award'

    fill_in 'Award title', with: 'Gold award'

    click_on 'Ask'

    fill_in 'Your answer', with: 'new answer body'
    click_on 'Create'
    wait_for_ajax

    click_on 'Mark as best'

    visit user_path(user)
    expect(page).to have_content 'Gold award'
  end
end
