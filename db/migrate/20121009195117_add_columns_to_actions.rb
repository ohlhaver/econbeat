class AddColumnsToActions < ActiveRecord::Migration
  def change
  	add_column :actions, :article_id, :integer
  	add_column :actions, :post_id, :integer
  	add_column :actions, :user_id, :integer
  	add_column :actions, :author_id, :integer
  	remove_column :actions, :obj_id
  	remove_column :actions, :subject_id

  end
end
