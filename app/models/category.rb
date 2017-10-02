class Category < ApplicationRecord
  has_ancestry

  def level
    self.depth + 1
  end

  def self.leaves
    self.all.select { |catgory| catgory.is_childless? }
  end
end
