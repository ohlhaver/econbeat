class AddIndexToActions < ActiveRecord::Migration
  def change
  	add_index :actions, :user_id
  	add_index :actions, :author_id
  end
end
