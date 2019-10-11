class CreateCourses < ActiveRecord::Migration[5.1]
  def change
    create_table :courses do |t|
      t.string :proto_id, null: false
      t.string :name
      t.integer :subject_id, null: false
      t.integer :grade_id, null: false
      t.json :attrs

      t.timestamps
    end
    add_index :courses, :proto_id, unique: true
    add_index :courses, :subject_id
    add_index :courses, :grade_id

  end
end
