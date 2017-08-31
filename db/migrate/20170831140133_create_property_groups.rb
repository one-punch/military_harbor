class CreatePropertyGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :property_groups do |t|

      t.timestamps
    end
  end
end
