class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.text :text
      t.references :commentable, :polymorphic => true
      t.integer :up_votes, :null => false, :default => 0
			t.integer :down_votes, :null => false, :default => 0
			
      t.timestamps
    end
  end
end
