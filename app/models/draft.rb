class Draft < ApplicationRecord
  self.primary_key = "article_token"

  belongs_to :user, foreign_key: "user_token"
  validates :article_token, uniqueness: true
end
