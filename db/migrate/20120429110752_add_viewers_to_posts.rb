class AddViewersToPosts < ActiveRecord::Migration
  def change
  	add_column :posts, :viewers, :integer 
  end
end
