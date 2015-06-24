require 'rails'
require 'active_support/dependencies'
require 'forwardable'
require 'maini/auth/version'
require 'maini/utils/error'
require 'devise'
require 'active_model_serializers'

module Maini
  module Auth

    autoload :Configuration,          'maini/auth/configuration'
    autoload :Handler,                'maini/auth/handler'
    autoload :Models,                 'maini/auth/models'

    class << self

      def setup(&block)
        Maini::Auth::Configuration.setup(&block)
      end

    end

  end
end

require 'maini/auth/routing'
require 'maini/auth/engine'
require 'maini/auth/active_record'
require 'maini/auth/controller_addictions'
require 'maini/auth/action_controller'
