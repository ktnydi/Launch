class AddCountColumnToLikes < ActiveRecord::Migration[6.0]
  def change
    add_column :likes, :count, :integer, null: false, default: 0
  end
end
