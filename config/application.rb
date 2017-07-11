require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env)

Sidekiq::Extensions.enable_delay!

Raven.configure do |config|
  config.dsn = 'https://ec5439b2fa314c60a8ed992e479f0bd8:37b0fa41c1434115aa9d5fd88de957f7@sentry.io/185292'
end


module Myflix
  class Application < Rails::Application
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.active_support.escape_html_entities_in_json = true

    config.assets.enabled = true
    config.generators do |g|
      g.orm :active_record
      g.template_engine :haml
    end
  end
end
