module Users
  class RegistrationsController < Devise::RegistrationsController
    include CommonHelper
    before_action :configure_sign_up_params, only: [:create]
    # before_action :configure_account_update_params, only: [:update]
    layout 'without_sidebar'

    # GET /resource/sign_up
    def new
      flash.now[:event] = google_analytics_event_tracking('Register', 'Clicked')
      super
    end

    # POST /resource
    # def create
    #   super
    # end

    protected

    # If you have extra params to permit, append them to the sanitizer.
    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    end
  end
end
