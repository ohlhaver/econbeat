class CreateEconlists < ActiveRecord::Migration
  def change
    create_table :econlists do |t|
      t.text :top_authors

      t.timestamps
    end
  end
end
