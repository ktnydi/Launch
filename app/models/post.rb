class Post < ApplicationRecord
  belongs_to :user

  validates :title, presence: true,
                    length: { maximum: 50 }
  validates :content, presence: true
  is_impressionable counter_cache: true, unique: true
end
