class RenameArticleTokenColumnToBookmarks < ActiveRecord::Migration[6.0]
  def change
    rename_column :bookmarks, :article_token, :entry_token
  end
end
