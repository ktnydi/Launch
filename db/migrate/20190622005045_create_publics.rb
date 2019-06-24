class CreatePublics < ActiveRecord::Migration[5.2]
  def change
    create_table :publics do |t|
      t.string :article_token, null: false
      t.string :title, null: false
      t.string :category, null: false
      t.text :content, null: false
      t.string :user_token, null: false
      t.timestamps
    end
  end
end
