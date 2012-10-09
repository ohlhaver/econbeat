class AddIndexToSubscriptions < ActiveRecord::Migration
  def change
  	 add_index "subscriptions", ["user_id", "author_id"], :name => "index_subscriptions_on_user_id_and_author_id", :unique => true
  end
end
