module Maini
  module Auth
    module ControllerAddictions

      module ClassMethods

        def maini_auth_public(**args)
          @maini_auth_public_options = args
          include Maini::Auth::ControllerAddictions::MakePublic
        end

      end

      def self.included(base)
        base.extend ClassMethods
      end

      module MakePublic
        extend ActiveSupport::Concern

        included do
          skip_before_action :verify_authenticity_token, @maini_auth_public_options
          skip_before_action :authenticate_user_from_token!, @maini_auth_public_options
          skip_before_action :authenticate_user!, @maini_auth_public_options
        end

      end

    end

  end
end