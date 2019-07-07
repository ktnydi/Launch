class DeleteCountsTable < ActiveRecord::Migration[5.2]
  def up
    remove_column :posts, :pv_count
  end

  def down
    add_column :posts, :pv_count, default: 0, null: false
  end
end
