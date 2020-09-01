class Property < ApplicationRecord
  belongs_to :variant, class_name: "Variant"

  enum key: [:subscribe, :download]

  KEY_DISPLAY = {
    subscribe: "查看",
    download: "查看与下载"
  }

  validates :key, presence: true, uniqueness: { scope: :variant_id }
  validates :value, presence: true, uniqueness: { scope: :variant_id }

  def expired_at
    if subscribe? && value.to_i > 0
      Time.now.beginning_of_day + value.to_i.days #单位 day
    end
  end

  def allow_download?
    download? && value == "true"
  end

  def days
    value.to_i if subscribe? && value.to_i > 0
  end

end
