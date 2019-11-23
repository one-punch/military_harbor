class AddGroupIdIngrade < ActiveRecord::Migration[5.1]
  def change
    add_column :grades, :group_id, :integer
    add_index  :grades, :group_id
    Grade.where("name LIKE ?", "%年级").update_all(group_id: Grade::GROUP["primary"])
    Grade.where("name LIKE ?", "初%").update_all(group_id: Grade::GROUP["middle"])
    Grade.where("name LIKE ?", "高%").update_all(group_id: Grade::GROUP["high"])
  end
end
