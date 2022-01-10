require 'sphinx_helper'

feature 'User can search for resources', %q{
  In order to find needed resource
  As a User
  I'd like to be able to search for the resources
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:answer) { create(:answer, question: question, author: user) }
  given(:comment) { create(:comment, commentable: question, author: user) }

  background do
    sign_in(user)
    visit root_path
  end

  scenario 'User searches for the question', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
       fill_in 'Find', with: 'MyString'
       choose 'Question'
       click_on 'Search'

       expect(page).to have_link 'MyString'
    end
  end

  scenario 'User searches for the answer', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
       fill_in 'Find', with: 'MyText'
       choose 'Answer'
       click_on 'Search'

       expect(page).to have_link 'MyText'
    end
  end

  scenario 'User searches for the comment', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
       fill_in 'Find', with: 'MyCommentText'
       choose 'Comment'
       click_on 'Search'

       expect(page).to have_link 'MyCommentText'
    end
  end

  scenario 'User searches for the user', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
       fill_in 'Find', with: another_user.email
       choose 'User'
       click_on 'Search'

       expect(page).to have_link another_user.email
    end
  end
end
