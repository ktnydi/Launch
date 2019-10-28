class ChangeStringTagToEntries < ActiveRecord::Migration[6.0]
  def change
    change_column :entries, :tag, :text
  end
end
