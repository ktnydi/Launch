class DeleteCountsTable < ActiveRecord::Migration[5.2]
  def up
    drop_table :counts
    remove_column :posts, :pv_count
  end

  def down
    create_table :counts do |t|
      t.string "user_id", null: false
      t.string "post_id", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
    add_column :posts, :pv_count, default: 0, null: false
  end
end
