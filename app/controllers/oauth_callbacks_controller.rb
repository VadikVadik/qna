class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    sign_in_with('Github')
  end

  def google_oauth2
    sign_in_with('Google')
  end

  private

  def sign_in_with(provider)
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end
