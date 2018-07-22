class Picture < ApplicationRecord
  belongs_to :imageable, polymorphic: true, optional: true


  BASE_URL = 'https://www.militaryharbor.net'

  def url
    "#{BASE_URL}/#{self.name}"
  end

end
