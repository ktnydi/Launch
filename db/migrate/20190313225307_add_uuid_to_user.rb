class AddUuidToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :uuid, :string, null: false, default: "", index: true
  end
end
