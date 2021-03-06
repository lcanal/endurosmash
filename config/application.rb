require_relative "boot"

require "rails/all"
# require "logger"


# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Endurosmash
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    Strava::OAuth.configure do |config|
      config.client_id = ENV['STRAVA_CLIENT_ID']
      config.client_secret = ENV['STRAVA_CLIENT_SECRET']
    end

    # Strava::Web::Client.configure do |config|
    #   logger = Logger.new(STDOUT)
    #   config.user_agent = 'Strava Ruby Client/1.0'
    #   config.logger = logger
    # end
  end
end
