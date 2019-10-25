class Course < ApplicationRecord
  belongs_to :subject
  belongs_to :grade
  has_many :materials, primary_key: "proto_id", foreign_key: "proto_course_id"

  serialize :attrs, JSON
end
