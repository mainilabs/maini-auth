require 'rails/generators/active_record'
require 'generators/maini/orm_helpers'

module ActiveRecord
  module Generators
    class AuthGenerator < ActiveRecord::Generators::Base
      include Maini::Generators::OrmHelpers
      source_root File.expand_path("../templates", __FILE__)

      def copy_auth_migration
        if (behavior == :invoke && model_exists?) || (behavior == :revoke && migration_exists?(table_name))
          migration_template "migration_existing.rb", "db/migrate/add_maini_auth_to_#{table_name}.rb"
        else
          migration_template "migration.rb", "db/migrate/maini_auth_create_#{table_name}.rb"
        end
      end

      def migration_data
<<RUBY
      t.references :user, index: true
      t.string :platform
      t.string :register
      t.string :authentication_token
RUBY
      end

    end
  end
end
