class AddHiddenToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :hidden, :boolean
  end
end
