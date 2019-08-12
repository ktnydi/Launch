class Request < ApplicationRecord
  self.primary_key = "token"

  belongs_to :user, foreign_key: "user_token"

  validates :category, presence: true, length: {maximum: 100}
  validates :content, length: {maximum: 500}
end
