class RenameEntryTokenColumnToEntrys < ActiveRecord::Migration[6.0]
  def change
    rename_column :entries, :entry_token, :token
  end
end
