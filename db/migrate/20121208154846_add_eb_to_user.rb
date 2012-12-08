class AddEbToUser < ActiveRecord::Migration
  def change
    add_column :users, :eb, :boolean
  end
end
