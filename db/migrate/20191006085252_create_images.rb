class CreateImages < ActiveRecord::Migration[6.0]
  def change
    create_table :images do |t|
      t.string :filename
      t.binary :file
      t.string :user_token, null: false, default: "", index: true

      t.timestamps
    end
  end
end
