class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.integer :subject_type
      t.integer :subject_id
      t.integer :action_type
      t.integer :object_type
      t.integer :object_id

      t.timestamps
    end
  end
end
