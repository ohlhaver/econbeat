class AddAuthorObjIdToActions < ActiveRecord::Migration
  def change
  	add_column :actions, :author_obj_id, :integer
  end
end
