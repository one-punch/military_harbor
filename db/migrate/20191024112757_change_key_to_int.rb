class ChangeKeyToInt < ActiveRecord::Migration[5.1]
  def change
    change_column :properties, :key, :integer, default: 0
  end
end
