class Post < ApplicationRecord
  has_many :comments, dependent: :destroy
  belongs_to :user

  validates :title, presence: true,
                    length: { maximum: 50 }
  validates :content, presence: true
  is_impressionable counter_cache: true, unique: true

  def self.search(query)
    rel = order(created_at: :desc)
    if query.present?
      rel = rel.where("title LIKE ?", "%#{query}%")
    end
    rel
  end
end
