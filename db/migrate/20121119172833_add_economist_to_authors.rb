class AddEconomistToAuthors < ActiveRecord::Migration
  def change
    add_column :authors, :economist, :boolean
  end
end
