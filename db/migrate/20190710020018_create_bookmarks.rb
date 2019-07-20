class CreateBookmarks < ActiveRecord::Migration[5.2]
  def change
    create_table :bookmarks do |t|
      t.string :user_token, null: false
      t.string :article_token, null: false

      t.timestamps
    end
  end
end
