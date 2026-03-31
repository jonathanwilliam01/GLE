require_relative 'boot'

require 'rails'
require 'active_model/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_dispatch/railtie'

Bundler.require(*Rails.groups)

module Gle
  class Application < Rails::Application
    config.load_defaults 7.0
    config.api_only = true
    config.time_zone = 'Brasilia'
    config.i18n.default_locale = :'pt-BR'

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*',
          headers: :any,
          methods: [:get, :post, :put, :patch, :delete, :options, :head]
      end
    end

    # Autoload support classes (JsonWebToken)
    config.autoload_paths += %W[#{config.root}/app/support]
  end
end
