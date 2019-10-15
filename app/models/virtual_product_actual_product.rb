class VirtualProductActualProduct < ApplicationRecord

  belongs_to :virtual_product, class_name: "VirtualProduct"
  belongs_to :actual_product, class_name: "Product"


end
