class AddGeetestConfig < ActiveRecord::Migration[5.1]
  def change
    Setting.where(key: Setting::GEETEST_ID).first_or_create(value: "a0ccb2093b56b13431205fcd98bf2e77")
    Setting.where(key: Setting::GEETEST_KEY).first_or_create(value: "80f1eea5c0fae877fc8270c946b6fb66")
  end
end
