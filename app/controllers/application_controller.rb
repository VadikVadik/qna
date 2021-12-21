class ApplicationController < ActionController::Base
  def current_ability
  if request.fullpath =~ /\/api/
    @current_ability ||= Ability.new(current_resource_owner)
  else
    @current_ability ||= Ability.new(current_user)
  end
end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  # check_authorization
end
