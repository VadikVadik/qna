require 'rails_helper'

feature 'User can view the list of questions', %q{
  In order to find an answer from the community
  To the question of interest
  I would like to be able to view a list of all the questions
} do
  given!(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3, author: user) }

  scenario 'User views the list of all questions' do
    visit questions_path

    expect(page).to have_content 'All questions'
    Question.pluck(:title).each { |title| expect(page).to have_content title }
  end
end
