module Maini
  module Auth
    module Handler
      extend ActiveSupport::Concern

      included do
        protected :authenticate_user_from_token!

        before_action :authenticate_user_from_token!
        before_action :authenticate_user!, :unless => :devise_controller?

        skip_before_action :verify_authenticity_token
      end

      def authenticate_user_from_token!
        param_user_token      = params[Maini::Auth::Configuration.auth_params[:login]]
        param_login_token     = params[Maini::Auth::Configuration.auth_params[:token]]
        param_device_register = params[Maini::Auth::Configuration.auth_params[:register]]

        if param_user_token.blank? && request.headers[Maini::Auth::Configuration.auth_headers[:token]]
          param_user_token = request.headers[Maini::Auth::Configuration.auth_headers[:token]]
        end

        if param_login_token.blank? && request.headers[Maini::Auth::Configuration.auth_headers[:login]]
          param_login_token = request.headers[Maini::Auth::Configuration.auth_headers[:login]]
        end

        if param_device_register.blank? && request.headers[Maini::Auth::Configuration.auth_headers[:register]]
          param_device_register = request.headers[Maini::Auth::Configuration.auth_headers[:register]]
        end

        user_token      = param_user_token.presence
        user_login      = param_login_token.presence
        device_register = param_device_register.presence

        unless Rails.env.production?
          puts '=HEADERS===================================================================================================='.green
          puts "#{'X-User-Token:'.cyan.bold} #{param_user_token}"
          puts "#{'X-User-Email:'.cyan.bold} #{param_login_token}"
          puts "#{'X-Device-Register:'.cyan.bold} #{param_device_register}"
          puts '============================================================================================================'.green
        end

        user = user_login && User.find_by(email: user_login)

        device = user && device_register && user.devices.find_by(register: device_register)

        if device && Devise.secure_compare(device.authentication_token, user_token)
          sign_in :user, user, store: false
        end

      end
    end
  end
end