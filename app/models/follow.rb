class Follow < ApplicationRecord
  belongs_to :following,
              class_name: "User",
              foreign_key: "followed_user_id"
  belongs_to :followed,
              class_name: "User",
              foreign_key: "following_user_id"
end
