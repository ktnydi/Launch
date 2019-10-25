class CreateEntries < ActiveRecord::Migration[6.0]
  def change
    create_table :entries do |t|
      t.string :entry_token
      t.integer :status, default: 0, null: false
      t.string :title, default: "", null: false
      t.string :tag, default: ""
      t.text :content, default: ""
      t.string :user_token
      t.timestamps
    end
    add_index :entries, :entry_token, unique: true
  end
end
