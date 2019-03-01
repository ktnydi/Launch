class ModifyUsers < ActiveRecord::Migration[5.2]
  def up
    change_column :users, :image_name, :string, null: false, default: "default.png"
  end

  def down
    change_column :users, :image_name, :string
  end
end
