class Public < ApplicationRecord
  belongs_to :user, foreign_key: "user_token"
  validates :article_token, presence: true, uniqueness: true
  validates :title, presence: true, length: { maximum: 50 }
  validates :category, presence: true, length: { maximum: 20 }
  validates :content, presence: true, length: { maximum: 3000 }
  validates :user_token, presence: true
end
