class AddUtopicIdToPosts < ActiveRecord::Migration
  def change
  	add_column :posts, :utopic_id, :integer
  end
end
