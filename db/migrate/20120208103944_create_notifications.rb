class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.boolean :unread, :default => true
      t.references :alerted, :polymorphic => true
      t.references :alertable, :polymorphic => true

      t.timestamps
    end
  end
end
