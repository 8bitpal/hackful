class CreateAdminAuths < ActiveRecord::Migration
  def change
    create_table :admin_auths do |t|
      t.integer :user_id
      t.string :resource
      t.string :action

      t.timestamps
    end
  end
end
