class RenameArticleTokenColumnToLikes < ActiveRecord::Migration[6.0]
  def change
    rename_column :likes, :article_token, :entry_token
  end
end
