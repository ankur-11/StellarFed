Rails.configuration.after_initialize do
  User.select(:email, :account_id).each do |user|
    StellarFederation::Application::CACHE_CLIENT.sadd(user.account_id, user.email) rescue nil
  end
end
