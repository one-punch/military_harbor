class Property < ApplicationRecord
  belongs_to :variant, class_name: "Variant"

  validates :key, presence: true, uniqueness: { scope: :variant_id }
  validates :value, presence: true, uniqueness: { scope: :variant_id }

end
