require 'securerandom'
class PaperViewerService

  def self.prepare(user, paper_id, type)
    random_string = SecureRandom.hex
    REDIS_STORE.mapped_hmset("viewer/#{user.id}/#{random_string}", {id: paper_id, type: type})
    REDIS_STORE.expire("viewer/#{user.id}/#{random_string}", 2.minutes)
    random_string
  end

  def self.pop(user, token)
    str = REDIS_STORE.hgetall("viewer/#{user.id}/#{token}")
    REDIS_STORE.del("viewer/#{user.id}/#{token}")
    str
  end


end