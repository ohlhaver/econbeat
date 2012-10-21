class AddHiddenToAuthors < ActiveRecord::Migration
  def change
    add_column :authors, :hidden, :boolean
  end
end
