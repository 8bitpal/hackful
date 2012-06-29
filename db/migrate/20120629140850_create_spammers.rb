class CreateSpammers < ActiveRecord::Migration
  def change
    create_table :spammers do |t|
      t.references :user
      t.string :reason

      t.timestamps
    end
    add_index :spammers, :user_id
  end
end
