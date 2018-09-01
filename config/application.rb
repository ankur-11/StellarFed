require_relative 'boot'

require 'rails/all'
require 'redis'
require 'dotenv/load'
require 'stellar-sdk'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module StellarFed
  class Application < Rails::Application
    CACHE_CLIENT = Redis.new(url: ENV['REDIS_URL'])
    DOMAIN = 'stellarfed.org'
    DONATION_ACCOUNT = 'ankurpatel@me.com'

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.before_initialize do
      config.domain = StellarFed::Application::DOMAIN
    end

    config.action_mailer.default_url_options = { host: StellarFed::Application::DOMAIN }
  end
end
