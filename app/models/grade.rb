class Grade < ApplicationRecord

  GROUP = {
    "primary" => 1,
    "middle" => 2,
    "high" => 3
  }

  def group_name
    Grade::GROUP.invert[group_id]
  end

end
