class CreateMaterials < ActiveRecord::Migration[5.1]
  def change
    create_table :materials do |t|
      t.string :proto_id, null: false
      t.string :name
      t.integer :number, default: 0
      t.string :proto_course_id, null: false

      t.timestamps
    end
    add_index :materials, :proto_id, unique: true
    add_index :materials, :proto_course_id
  end
end
