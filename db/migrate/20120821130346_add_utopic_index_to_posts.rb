class AddUtopicIndexToPosts < ActiveRecord::Migration
  def change
  end
  add_index :posts, [:utopic_id]
end
