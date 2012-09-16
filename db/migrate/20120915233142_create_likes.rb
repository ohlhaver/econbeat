class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.string :fbid
      t.integer :user_id
      t.integer :post_id

      t.timestamps
    end
  end
end
