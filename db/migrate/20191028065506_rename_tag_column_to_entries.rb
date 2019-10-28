class RenameTagColumnToEntries < ActiveRecord::Migration[6.0]
  def up
    rename_column :entries, :tag, :tags
  end
end
