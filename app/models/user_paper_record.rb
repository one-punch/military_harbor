class UserPaperRecord < ApplicationRecord

  def not_expired?
    !expired?
  end

  def expired?
    Time.now > expired_at
  end

  def reset_expired_at_from_now(days)
    self.expired_at = Time.now.beginning_of_day + days.days
  end

  def stretch(days)
    if !expired?
      self.expired_at = expired_at + days.days
    end
  end

end
