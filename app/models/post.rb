class Post < ApplicationRecord
  require "securerandom"
  self.primary_key = "uuid"

  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  belongs_to :user

  validates :title, presence: true,
                    length: { maximum: 50 }
  validates :content, presence: true, length: { maximum: 5000 }

  def self.search(query)
    rel = order(created_at: :desc)
    if query.present?
      rel = rel.where("title LIKE ?", "%#{query}%")
    end
    rel
  end

  def self.status_public
    where(status: "公開中")
  end

  def like_user(user_id)
    likes.find_by(user_id: user_id)
  end
end
