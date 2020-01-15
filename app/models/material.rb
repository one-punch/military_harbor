class Material < ApplicationRecord
  belongs_to :course, primary_key: "proto_id", foreign_key: "proto_course_id"
  has_many :papers, primary_key: "proto_id", foreign_key: "proto_material_id"
  belongs_to :parent, primary_key: "proto_id", foreign_key: "proto_parent_id", class_name: "Material"
  has_many :child, primary_key: "proto_id", foreign_key: "proto_parent_id", class_name: "Material"

  serialize :attrs, JSON
end
