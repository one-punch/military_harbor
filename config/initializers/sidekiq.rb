require 'sidekiq/web'

namespace = "sidekiq"
Sidekiq.configure_server do |config|
  config.redis = { url: "#{YAML_CONFIG[:redis][:sidekiq]}" }

  # A Sidekiq server process requires at least (concurrency + 5) connections.
  ActiveRecord::Base.configurations[Rails.env]['pool'] = 30
  ActiveRecord::Base.establish_connection
end

Sidekiq.configure_client do |config|
  config.redis = { url: "#{YAML_CONFIG[:redis][:sidekiq]}" }
end