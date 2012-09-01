class AddFbidToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :fbid, :string
  end
end
