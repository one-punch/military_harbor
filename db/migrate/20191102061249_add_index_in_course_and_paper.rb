class AddIndexInCourseAndPaper < ActiveRecord::Migration[5.1]
  def change
    add_index :courses, :type_name
  end
end
