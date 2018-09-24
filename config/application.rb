require_relative 'boot'

require 'rails/all'
require 'redis'
require 'stellar-sdk'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module StellarFed
  class Application < Rails::Application
    CACHE_CLIENT = Redis.new(url: Rails.application.secrets.cache_server_url)
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

    config.middleware.insert_after ActionDispatch::Static, Rack::Deflater

    compression_options = {
      enabled: true,
      remove_spaces_inside_tags: true,
      remove_multi_spaces: true,
      remove_comments: true,
      remove_intertag_spaces: true
    }
    config.middleware.use HtmlCompressor::Rack, compression_options
  end
end
