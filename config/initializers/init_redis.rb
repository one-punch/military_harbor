require "redis"

REDIS_STORE = Redis.new(url: YAML_CONFIG[:redis][:url_0])