class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string  :title,    null: false, limit: 50
      t.text    :content,  null: false
      t.integer :user_id,  null: false
      t.column  :private, :tinyint, null: false, default: 0

      t.timestamps
      t.datetime :deleted_at
      t.integer :lock_version, default: 0
    end

    add_index :articles, :title, unique: true
  end
end
