class AddFbactionIdToActions < ActiveRecord::Migration
  def change
    add_column :actions, :fbaction_id, :string
  end
end
