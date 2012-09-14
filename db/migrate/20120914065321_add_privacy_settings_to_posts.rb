class AddPrivacySettingsToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :public, :boolean
    add_column :posts, :facebook, :boolean
    add_column :posts, :email, :boolean
  end
end
