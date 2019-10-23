require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MilitaryHarbor
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.active_job.queue_adapter = :sidekiq

    config.autoload_paths += %W(
      #{config.root}/app/uploaders
      #{config.root}/app/third_api
    )
    # config.eager_load_paths += config.autoload_paths
  end
end

YAML_CONFIG = YAML.load_file("#{Rails.root}/config/#{Rails.env}_config.yml").deep_symbolize_keys
