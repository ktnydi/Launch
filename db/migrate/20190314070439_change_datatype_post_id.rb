class ChangeDatatypePostId < ActiveRecord::Migration[5.2]
  def change
    change_column :comments, :post_id, :string, null: false
    change_column :likes, :post_id, :string, null: false
  end
end
