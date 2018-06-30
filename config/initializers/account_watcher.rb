require 'redis'

Rails.configuration.after_initialize do
  redis = Redis.new(url: ENV['REDIS_URL'])
  unless redis.nil?
    User.select(:email, :account_id).each do |user|
      redis.lpush(user.account_id, user.email) rescue nil
    end
  end
end
