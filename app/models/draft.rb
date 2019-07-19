class Draft < ApplicationRecord
  self.primary_key = "article_token"

  belongs_to :user, foreign_key: "user_token"
  validates :article_token, presence: true, uniqueness: true
  validates :title, length: { maximum: 50 }
  validates :category, length: { maximum: 20 }
  validates :content, length: { maximum: 10000 }
  validates :user_token, presence: true

  def self.search(query)
    rel = order(created_at: :desc)
    if query.present?
      rel = rel.where("title LIKE ?", "%#{query}%")
    end
    rel
  end
end
