class AddFilenameInPaper < ActiveRecord::Migration[5.1]
  def change
    add_column :papers, :student_file, :string
    add_column :papers, :tearcher_file, :string
  end
end
