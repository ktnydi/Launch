class AddUuidToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :uuid, :string, null: false, default: "", index: true
  end
end
