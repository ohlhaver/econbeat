class AddViaToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :via_id, :integer
  end
end
