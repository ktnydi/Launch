class Entry < ApplicationRecord
  self.primary_key = "token"
  serialize :tags

  has_many :bookmarks, foreign_key: "entry_token", dependent: :destroy
  has_many :likes, foreign_key: "entry_token", dependent: :destroy
  has_many :comments, foreign_key: "entry_token", dependent: :destroy
  belongs_to :user, foreign_key: "user_token"

  validates :title, presence: true, length: { maximum: 50 }
  validates :tags, length: { maximum: 50 }
  validates :content, length: { maximum: 10000 }

  has_secure_token :token

  scope :publics, -> { self.where(status: 1) }
  scope :drafts, -> { self.where(status: 0) }
  scope :new_order, -> { self.order(created_at: :desc) }
  scope :search, -> (query) do
    self.where("title LIKE ? OR tags LIKE ?", "%#{query}%", "%#{query}%")
  end

  before_save :tags_to_array

  :private
    def tags_to_array
      self.tags = self.tags.split(",")
    end
end
