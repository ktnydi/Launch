class CreateDrafts < ActiveRecord::Migration[5.2]
  def change
    create_table :drafts do |t|
      t.string :article_token
      t.string :title
      t.string :category
      t.text :content
      t.string :user_token
      t.timestamps
    end
  end
end
