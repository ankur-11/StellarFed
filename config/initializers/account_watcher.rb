Rails.configuration.after_initialize do
  User.update_cache
  Account.update_watch
end
