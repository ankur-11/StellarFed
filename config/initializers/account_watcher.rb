Rails.configuration.after_initialize do
  User.where(receive_email_notifications: true).each(&:cache)
end
