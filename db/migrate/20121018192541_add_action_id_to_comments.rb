class AddActionIdToComments < ActiveRecord::Migration
  def change
    add_column :comments, :action_id, :integer
  end
end
