class AddQrcodeUrl < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :qrcode_url, :string
    add_column :orders, :expired_at, :datetime
  end
end
