class RenameArticleTokenColumnToAccessAnalyses < ActiveRecord::Migration[6.0]
  def change
    rename_column :access_analyses, :article_token, :entry_token
  end
end
