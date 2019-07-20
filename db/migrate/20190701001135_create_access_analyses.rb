class CreateAccessAnalyses < ActiveRecord::Migration[5.2]
  def change
    create_table :access_analyses do |t|
      t.string :article_token, null: false
      t.string :access_source, null: false
      t.string :user_token, null: false, default: ""
      t.timestamps
    end
  end
end
