require 'active_support/core_ext/string'

module ActionDispatch::Routing
  class Mapper

    def maini_auth(resource, **args)
      options         = Maini::Auth::Configuration.routing.merge(args)
      devise_options  = Maini::Auth::Configuration.devise_route_config.merge(options[:devise]||{})

      devise_for resource.to_sym, devise_options

      devise_scope resource.to_s.singularize.to_sym do

        post    "#{options[:path]}"        => "#{options[:controller]}#create"
        delete  "#{options[:path]}"        => "#{options[:controller]}#destroy"
        get     "#{options[:path]}/check"  => "#{options[:controller]}#check"

        if block_given?
          yield
        end

      end

    end

  end
end