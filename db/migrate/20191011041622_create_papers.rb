class CreatePapers < ActiveRecord::Migration[5.1]
  def change
    create_table :papers do |t|
      t.string :proto_id, null: false
      t.string :name
      t.string :proto_material_id, null: false
      t.text :student
      t.text :tearcher
      t.string :type_name
      t.integer :number
      t.string :path
      t.timestamps
    end
    add_index :papers, :proto_id, unique: true
    add_index :papers, :proto_material_id
    add_index :papers, :type_name

  end
end
