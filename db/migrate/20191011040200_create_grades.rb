class CreateGrades < ActiveRecord::Migration[5.1]
  def change
    create_table :grades do |t|
      t.string  :name, null: false

      t.timestamps
    end
  end
end
