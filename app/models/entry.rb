class Entry < ApplicationRecord
  self.primary_key = "entry_token"

  belongs_to :user, foreign_key: "user_token"

  validates :title, presence: true, length: { maximum: 50 }
  validates :tag, length: { maximum: 50 }
  validates :content, length: { maximum: 10000 }

  has_secure_token :entry_token
end
