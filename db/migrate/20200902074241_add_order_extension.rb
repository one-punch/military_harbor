class AddOrderExtension < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :extension, :string
  end
end
