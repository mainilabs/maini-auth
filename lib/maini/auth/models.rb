module Maini
  module Auth
    module Models
      include Devise::Models

      def maini_auth
        include Maini::Auth::Authenticable

        devise_options = Maini::Auth::Configuration.devise_options

        devise *devise_options
      end

    end

    module Authenticable
      extend ActiveSupport::Concern

      included do
        has_many :devices, class_name: 'Maini::Auth::Device'
      end
    end

  end
end