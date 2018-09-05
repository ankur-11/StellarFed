class ChangeSecretKeyName < ActiveRecord::Migration[5.2]
  def change
    rename_column :accounts, :secret_key, :encrypted_secret_key
  end
end
