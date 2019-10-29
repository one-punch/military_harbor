class AddGradeGroupIdInCourses < ActiveRecord::Migration[5.1]
  def change
    add_column :courses, :grade_group_id, :integer, null: false
    add_column :courses, :type_name, :string, default: "教材"
  end
end
