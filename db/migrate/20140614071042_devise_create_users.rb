class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      ## Database authenticatable
      t.string :login_id,           null: false, limit: 30, default: ""
      t.string :encrypted_password, null: false, default: ""
      t.string :email

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      t.timestamps
      t.datetime :deleted_at
      t.integer :lock_version, :default => 0
    end

    add_index :users, :login_id,             unique: true
  end
end
