require 'rails/generators/base'
require 'securerandom'

module Maini
  module Generators
    class AuthGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      desc "Inicializa ."

      def copy_initializer
        template "auth.rb", "config/initializers/maini/auth.rb"
      end

      def copy_locale
        copy_file "../../../config/locales/en.yml", "config/locales/maini.auth.en.yml"
        copy_file "../../../config/locales/pt-BR.yml", "config/locales/maini.auth.pt-BR.yml"
      end

      def install_devise
        invoke "devise:install"
        invoke "devise", ["user"]
      end

      def create_device
        invoke "active_record:auth", ["device"]
      end

      def change_route
        gsub_file 'config/routes.rb', 'devise_for :users', 'maini_auth :users'
      end

      def change_user_model
        template "user.rb", "app/models/user.rb", force: true
      end

      def show_readme
        readme "README" if behavior == :invoke
      end

    end
  end
end
