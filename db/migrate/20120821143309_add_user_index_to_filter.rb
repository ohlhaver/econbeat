class AddUserIndexToFilter < ActiveRecord::Migration
  def change
  end
  add_index :filters, [:user_id]
end
