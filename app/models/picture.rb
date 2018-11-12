class Picture < ApplicationRecord
  belongs_to :imageable, polymorphic: true, optional: true
  validates :name, uniqueness: { scope: :imageable_id }

  BASE_URL = 'https://www.militaryharbor.net'

  NAMES = {
    'payment'   => 'webimg/abpay01',
    'tunic' => 'webimg/abgt01'
  }

  def url
    "#{BASE_URL}/#{self.name}"
  end

end
