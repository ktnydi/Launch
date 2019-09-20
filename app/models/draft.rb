class Draft < ApplicationRecord
  include Search
  self.primary_key = "article_token"

  belongs_to :user, foreign_key: "user_token"
  validates :article_token, presence: true, uniqueness: true
  validates :title, length: { maximum: 50 }
  validates :category, length: { maximum: 20 }
  validates :content, length: { maximum: 10000 }
  validates :user_token, presence: true
end
