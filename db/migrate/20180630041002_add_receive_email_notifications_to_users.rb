class AddReceiveEmailNotificationsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :receive_email_notifications, :boolean, default: true
  end
end
