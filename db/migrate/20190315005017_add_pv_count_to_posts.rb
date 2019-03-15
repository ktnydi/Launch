class AddPvCountToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :pv_count, :integer, null: false, default: 0
  end
end
