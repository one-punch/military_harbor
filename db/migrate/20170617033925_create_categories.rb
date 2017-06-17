class CreateCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :categories do |t|
      t.string   :name
      t.boolean :active, default: true
      t.integer  :ancestry_depth
      t.string   :ancestry
      t.timestamps
    end
  end
end
