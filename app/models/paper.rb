class Paper < ApplicationRecord
  belongs_to :material, primary_key: "proto_id", foreign_key: "proto_material_id"
  has_many   :exam_paper_elements, primary_key: "proto_id", foreign_key: "proto_paper_id"

  def student_version
    "#{name} (#{I18n.t('paper.student')})"
  end

  def teacher_version
    "#{name} (#{I18n.t('paper.teacher')})"
  end

end
