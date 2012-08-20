class AddTopicIndexToPosts < ActiveRecord::Migration
  def change
  end
  add_index :posts, [:topic_id]
end
