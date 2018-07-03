Rails.configuration.after_initialize do
  User.who_receive_notifications.each(&:cache) rescue nil
end
