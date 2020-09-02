class CancelOrderJob < ApplicationJob
  queue_as :default

  def perform
    Order.where("created_at < ?", 30.minutes.ago).where(status: [:wait_payment, :pending]).update_all(status: :cancel, updated_at: Time.zone.now)
  end

end