class AddStarredToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :starred, :boolean
  end
end
