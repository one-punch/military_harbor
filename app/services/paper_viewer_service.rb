require 'securerandom'
class PaperViewerService

  def self.prepare(user, paper_id)
    random_string = SecureRandom.hex
    REDIS_STORE.set("viewer/#{user.id}/#{random_string}", paper_id)
    REDIS_STORE.expire("viewer/#{user.id}/#{random_string}", 2.minutes)
    random_string
  end

  def self.pop(user, token)
    str = REDIS_STORE.get("viewer/#{user.id}/#{token}")
    REDIS_STORE.del("viewer/#{user.id}/#{token}")
    str
  end


end