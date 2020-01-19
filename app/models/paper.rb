class Paper < ApplicationRecord
  belongs_to :material, primary_key: "proto_id", foreign_key: "proto_material_id"
  has_many   :exam_paper_elements, primary_key: "proto_id", foreign_key: "proto_paper_id"

  scope :kno_ins, -> { where(type_name: "knoIns") }
  scope :chapter_exam, -> { where(type_name: "chapter_exam") }

  # type_name ['explain', 'work', 'courseware', 'exam']
  def student_version
    "#{name} (#{I18n.t('paper.student')})"
  end

  def teacher_version
    "#{name} (#{I18n.t('paper.teacher')})"
  end

  def is_exam?
    type_name == "exam"
  end

  def is_knowledge?
    type_name == "knoIns"
  end

  def is_chapter_exam?
    type_name == "chapter_exam"
  end

end
