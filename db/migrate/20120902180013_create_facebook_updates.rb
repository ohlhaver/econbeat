class CreateFacebookUpdates < ActiveRecord::Migration
  def change
    create_table :facebook_updates do |t|
      t.string :uid
      t.string :type

      t.timestamps
    end
  end
end
