class ApplicationController < ActionController::Base
  before_action :configure_devise_params, if: :devise_controller?
    
    protected
  
  def configure_devise_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:profile_img_url, :username])
  end
end
  
