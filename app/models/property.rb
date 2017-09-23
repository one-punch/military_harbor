class Property < ApplicationRecord
  validates :key, presence: true

  belongs_to :variant, class_name: "Variant"
end
