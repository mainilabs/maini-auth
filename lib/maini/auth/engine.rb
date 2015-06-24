module Maini
  module Auth
    class Engine < ::Rails::Engine
      config.autoload_paths += Dir["#{config.root}/lib/**/"]
      config.autoload_paths += Dir["#{config.root}/app/**/"]
      config.autoload_paths += Dir["#{config.root}/app/serializers/maini/auth/**/"]

      ActiveSupport.on_load(:active_model_serializers) do
        # Disable for all serializers (except ArraySerializer)
        ActiveModel::Serializer.root = false

        # Disable for ArraySerializer
        ActiveModel::ArraySerializer.root = false
      end

    end
  end
end