class Bookmark < ApplicationRecord
  belongs_to :user, foreign_key: "user_token"
  belongs_to :entry, foreign_key: "entry_token"

  validates :entry_token, uniqueness: { scope: :user_token }
end
