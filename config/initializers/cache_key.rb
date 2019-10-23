class ActiveRecord::Base
  def self.cache_key
    Digest::MD5.hexdigest("#{self.unscoped.maximum(:updated_at)}.try(:to_i)")
  end

  def self.last_updated_at
    self.all.maximum(:updated_at)
  end
end