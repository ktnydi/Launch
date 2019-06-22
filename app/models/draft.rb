class Draft < ApplicationRecord
  belongs_to :user, foreign_key: "user_token"
  validates :article_token, uniqueness: true
end
