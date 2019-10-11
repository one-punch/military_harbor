class Course < ApplicationRecord
  serialize :attrs, JSON
end
