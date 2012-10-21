class RenameAuthorIdColumn < ActiveRecord::Migration
  def change
  	rename_column :actions, :author_id, :catcher_id
  end
end
