require 'rails_helper'

feature 'Users can sign in with social networks accounts' do
  scenario "user can sign in with Github account with valid credentials" do
    visit new_user_session_path

    expect(page).to have_content "Sign in with GitHub"

    mock_github_auth_hash
    click_link "Sign in with GitHub"

    expect(page).to have_content "Successfully authenticated from Github account."
    expect(page).to have_content "Log Out"
  end

  scenario "user can't sign in with Github account with invalid credentials" do
    OmniAuth.config.mock_auth[:github] = :invalid_credentials

    visit new_user_session_path
    click_link "Sign in with GitHub"

    expect(page).to have_content "Could not authenticate you from GitHub because \"Invalid credentials\""
  end

  scenario "user can sign in with Google account" do
    visit new_user_session_path

    expect(page).to have_content "Sign in with GoogleOauth2"

    mock_google_auth_hash
    click_link "Sign in with GoogleOauth2"

    expect(page).to have_content "Successfully authenticated from Google account."
    expect(page).to have_content "Log Out"
  end

  scenario "user can't sign in with Google account with invalid credentials" do
    OmniAuth.config.mock_auth[:google_oauth2] = :invalid_credentials

    visit new_user_session_path
    click_link "Sign in with GoogleOauth2"

    expect(page).to have_content "Could not authenticate you from GoogleOauth2 because \"Invalid credentials\""
  end
end
