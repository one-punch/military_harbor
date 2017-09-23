class CreateProperties < ActiveRecord::Migration[5.1]
  def change
    create_table :properties do |t|
      t.integer :variant_id, null: false
      t.string  :key
      t.string  :value
      t.integer :position, default: 0
      t.timestamps
    end
  end
end
