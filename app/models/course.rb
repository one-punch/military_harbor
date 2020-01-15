class Course < ApplicationRecord
  belongs_to :subject
  belongs_to :grade
  has_many :materials,  -> { where("materials.proto_parent_id" => nil) }, primary_key: "proto_id", foreign_key: "proto_course_id"
  belongs_to :parent, primary_key: "proto_id", foreign_key: "proto_parent_id", class_name: "Course"
  has_many :child, primary_key: "proto_id", foreign_key: "proto_parent_id", class_name: "Course"

  scope :base, -> { where("courses.proto_parent_id" => nil) }

  serialize :attrs, JSON
end
