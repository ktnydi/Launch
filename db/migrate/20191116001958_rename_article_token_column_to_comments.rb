class RenameArticleTokenColumnToComments < ActiveRecord::Migration[6.0]
  def change
    rename_column :comments, :article_token, :entry_token
  end
end
