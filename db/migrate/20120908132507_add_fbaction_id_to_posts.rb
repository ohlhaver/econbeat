class AddFbactionIdToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :fbaction_id, :string
  end
end
