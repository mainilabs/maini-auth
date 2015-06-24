module Maini
  module Auth
    module Configuration

      mattr_accessor :name do
        "default"
      end

      mattr_accessor :routing do
        {path: 'auth/tokens', controller: 'maini/auth/tokens'}
      end

      mattr_accessor :devise_options do
        [:database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable, :lockable, :timeoutable]
      end

      mattr_accessor :devise_route_config do
        {path: 'auth', path_names: { :password => 'secret', :confirmation => 'verification', :unlock => 'unblock' }}
      end

      mattr_accessor :login_params do
        {login: :login, password: :password, register: :register, platform: :platform}
      end

      mattr_accessor :auth_params do
        {login: :login, token: :token, register: :register}
      end

      mattr_accessor :auth_headers do
        {login: 'X-Auth-Login', token: 'X-Auth-Token', register: 'X-Auth-Register'}
      end

      mattr_accessor :json_adapter do
        :jbuilder
      end

      mattr_accessor :locale_param do
        :locale
      end

      mattr_accessor :token_model do
        Maini::Auth::Token
      end

      mattr_accessor :token_serializer do
        Maini::Auth::TokenSerializer
      end

      class << self

        def setup(&block)
          yield self if block_given?
          self
        end

      end

    end
  end
end