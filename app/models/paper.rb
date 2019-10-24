class Paper < ApplicationRecord

  def student_version
    "#{name} (#{I18n.t('paper.student')})"
  end

  def teacher_version
    "#{name} (#{I18n.t('paper.teacher')})"
  end

end
