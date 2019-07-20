class Comment < ApplicationRecord
  validates :content, presence: true, length: { maximum: 1000 }
  belongs_to :user, foreign_key: "user_token"
  belongs_to :public, foreign_key: "article_token"
end
