class ChangeSecretKeyName < ActiveRecord::Migration[5.2]
  def change
    change_column :accounts, :secret_key, :string, limit: nil
    rename_column :accounts, :secret_key, :encrypted_secret_key
  end
end
