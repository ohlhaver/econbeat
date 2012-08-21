class CreateFilters < ActiveRecord::Migration
  def change
    create_table :filters do |t|
      t.integer :user_id
      t.integer :utopic_id

      t.timestamps
    end
  end
end
