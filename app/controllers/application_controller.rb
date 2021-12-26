class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html do
        redirect_to root_url, alert: exception.message
      end

      format.json do
        render json: {message: exception.message}, status: :forbidden
      end

      format.js do
        render json: {message: exception.message}, status: :forbidden
      end
    end
  end

  # check_authorization
end
