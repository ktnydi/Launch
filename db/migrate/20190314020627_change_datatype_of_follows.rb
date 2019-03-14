class ChangeDatatypeOfFollows < ActiveRecord::Migration[5.2]
  def change
    change_column :follows, :following_user_id, :string
    change_column :follows, :followed_user_id, :string
  end
end
