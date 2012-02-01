class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.string :title
      t.text :text
      t.text :link
      t.integer :up_votes, :null => false, :default => 0
			t.integer :down_votes, :null => false, :default => 0

      t.timestamps
    end
  end
end
