class AddColumnEntries < ActiveRecord::Migration[6.0]
  def change
    add_column :entries, :pv, :integer, null: false, default: 0
  end
end
