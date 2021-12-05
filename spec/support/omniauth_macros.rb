module OmniauthMacros
  def mock_github_auth_hash
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
      provider: 'guthub',
      uid: '123',
      info: {'email' => 'mockuser@example.com'},
      credentials: {
        'token' => 'mock_token',
        'secret' => 'mock_secret'
      })
  end

  def mock_google_auth_hash
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
      provider: 'google_oauth2',
      uid: '123',
      info: {'email' => 'mockuser@example.com'},
      credentials: {
        'token' => 'mock_token',
        'secret' => 'mock_secret'
      })
  end
end
