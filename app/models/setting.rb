class Setting < ApplicationRecord

  GEETEST_ID = "geetest_id".freeze
  GEETEST_KEY = "geetest_key".freeze
  DEFAULT_EXPIRED_DAYS = "default_expired_days".freeze

  class << self

    def geetest_config
      id = find_by(key: GEETEST_ID)
      key = find_by(key: GEETEST_KEY)
      {id: id&.value, key: key&.value}
    end

  end

end