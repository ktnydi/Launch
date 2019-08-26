class CreateRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :requests do |t|
      t.string :token
      t.string :category
      t.text :content, default: "情報がありません。"
      t.string :user_token
      t.timestamps
    end
  end
end
