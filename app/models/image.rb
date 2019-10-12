class Image < ApplicationRecord
  with_options presence: true do
    validates :user_token
  end
  validates :user_token, uniqueness: true

  belongs_to :user, foreign_key: "user_token"
end
