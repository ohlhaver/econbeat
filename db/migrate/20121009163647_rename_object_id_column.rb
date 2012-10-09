class RenameObjectIdColumn < ActiveRecord::Migration
  def change
  	rename_column :actions, :object_id, :obj_id
  end
end
