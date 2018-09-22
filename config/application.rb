require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module HubbIT
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.time_zone = 'Stockholm'
    config.autoload_paths << Rails.root.join('services')
    config.autoload_paths << Rails.root.join('channels')

    config.load_defaults 5.0

    config.cache_store = :redis_store, { :host => "localhost",
                                         :port => 6379,
                                         :db => 0,
                                         :namespace => "hubbit",
                                         :expires_in => 90.minutes }

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
