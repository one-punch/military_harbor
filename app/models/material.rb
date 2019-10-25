class Material < ApplicationRecord
  belongs_to :course, primary_key: "proto_id", foreign_key: "proto_course_id"
  has_many :papers, primary_key: "proto_id", foreign_key: "proto_material_id"

end
