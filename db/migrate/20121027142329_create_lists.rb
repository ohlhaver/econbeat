class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.text :top_authors

      t.timestamps
    end
  end
end
