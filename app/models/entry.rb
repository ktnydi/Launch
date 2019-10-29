class Entry < ApplicationRecord
  self.primary_key = "token"
  serialize :tags

  belongs_to :user, foreign_key: "user_token"

  validates :title, presence: true, length: { maximum: 50 }
  validates :tags, length: { maximum: 50 }
  validates :content, length: { maximum: 10000 }

  has_secure_token :token

  before_save :tags_to_array

  :private
    def tags_to_array
      self.tags = self.tags.split(",")
    end
end
