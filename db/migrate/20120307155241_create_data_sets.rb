class CreateDataSets < ActiveRecord::Migration
  def change
    create_table :data_sets do |t|
      t.integer :user_id
      t.boolean :contact_me, default: true
      t.string :twitter
      t.string :github
      t.string :linkedin
      t.string :url
      t.string :blog
      t.text :about_me

      t.timestamps
    end
  end
end
