class ModifyPosts < ActiveRecord::Migration[5.2]
  def up
    add_column :posts, :app_url, :string
    remove_column :posts, :image_name
  end

  def down
    add_column :posts, :image_name, :string
  end
end
