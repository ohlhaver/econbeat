class AddStarredtoSubscriptions < ActiveRecord::Migration
  def change
  	add_column :subscriptions, :starred, :boolean
  end
end
