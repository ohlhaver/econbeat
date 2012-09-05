class AddUserIndexToUtopics < ActiveRecord::Migration
  def change
  	add_index :utopics, [:user_id]
  end
end
