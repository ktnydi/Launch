class Draft < ApplicationRecord
  self.primary_key = "article_token"

  belongs_to :user, foreign_key: "user_token"
  validates :article_token, uniqueness: true

  def self.search(query)
    rel = order(created_at: :desc)
    if query.present?
      rel = rel.where("title LIKE ?", "%#{query}%")
    end
    rel
  end
end
