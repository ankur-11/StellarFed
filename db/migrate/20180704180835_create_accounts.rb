class CreateAccounts < ActiveRecord::Migration[5.2]
  def up
    create_table :accounts, id: false do |t|
      t.string :public_key, null: false, default: "", limit: 56
      t.string :secret_key, limit: 56
      t.string :email, null: false

      t.timestamps
    end
  end

  def down
    drop_table :accounts
  end
end
