class ChangeDatatypeUserIdOfPosts < ActiveRecord::Migration[5.2]
  def change
    change_column :posts, :user_id, :string, null: false, default: ""
  end
end
