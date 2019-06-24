class RenameColumn < ActiveRecord::Migration[5.2]
  def change
    rename_column :likes, :user_id, :user_token
    rename_column :likes, :post_id, :article_token
    rename_column :comments, :user_id, :user_token
    rename_column :comments, :post_id, :article_token
  end
end
