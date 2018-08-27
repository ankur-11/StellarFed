Rails.configuration.after_initialize do
  User.confirmed.who_receive_notifications.each(&:cache) rescue nil
end
