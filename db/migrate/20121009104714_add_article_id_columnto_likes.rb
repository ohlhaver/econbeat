class AddArticleIdColumntoLikes < ActiveRecord::Migration
  def change
  	add_column :likes, :article_id, :integer
  end
end
