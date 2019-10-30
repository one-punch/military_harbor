class ExamPaperElement < ApplicationRecord
  serialize :hideMainIdList, JSON
  serialize :hideQueIdList, JSON
  serialize :question, JSON
  serialize :attrs, JSON

end
