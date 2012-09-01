class AddIndexToPosts < ActiveRecord::Migration
  def change
    add_index :posts, :fbid, unique: true
  end
end
