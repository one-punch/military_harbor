class AddNumberInQuestion < ActiveRecord::Migration[5.1]
  def change
    add_column :questions, :number, :integer, default: 0
  end
end
