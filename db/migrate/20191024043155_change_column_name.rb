class ChangeColumnName < ActiveRecord::Migration[5.1]
  def change
    rename_column :papers, :tearcher, :teacher
    rename_column :papers, :tearcher_file, :teacher_file
  end
end
