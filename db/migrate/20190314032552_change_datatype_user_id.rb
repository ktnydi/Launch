class ChangeDatatypeUserId < ActiveRecord::Migration[5.2]
  def change
    change_column :comments, :user_id, :string, null: false
    change_column :likes, :user_id, :string, null: false
  end
end
