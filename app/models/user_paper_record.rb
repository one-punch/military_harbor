class UserPaperRecord < ApplicationRecord

  def expired?
    Time.now > expired_at
  end

  def reset_expired_at_from_now(days)
    expired_at = Time.now.beginning_of_day + days.days
  end

  def extend(days)
    if !expired?
      expired_at = expired_at + days.days
    end
  end

end
