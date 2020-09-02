class AddDefaultDays < ActiveRecord::Migration[5.1]
  def change
    Setting.where(key: Setting::DEFAULT_EXPIRED_DAYS).first_or_create(value: 100)
  end
end
