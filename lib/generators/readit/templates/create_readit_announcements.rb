class CreateReaditAnnouncements < ActiveRecord::Migration
  def change
    create_table :readit_announcements do |t|
      t.text :content
      t.boolean :is_active
      t.datetime :start_at
      t.datetime :stop_at
      t.string :content_digest, null: false, default: ''

      t.timestamps
    end

    add_index :readit_announcements, :is_active
    add_index :readit_announcements, :start_at
    add_index :readit_announcements, :stop_at
    add_index :readit_announcements, [:start_at, :stop_at], unique: false
    add_index :readit_announcements, :content_digest
  end
end
