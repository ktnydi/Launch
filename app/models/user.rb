class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post
  # フォローしたユーザー
  has_many :active_follows,
            class_name: "Follow",
            foreign_key: "following_user_id",
            dependent: :destroy
  has_many :followings,
            through: :active_follows,
            source: :following
  # フォローされたユーザー
  has_many :passive_follows,
            class_name: "Follow",
            foreign_key: "followed_user_id",
            dependent: :destroy
  has_many :followers,
            through: :passive_follows,
            source: :followed

  validates :name, presence: true, length: { maximum: 10 }
  attr_accessor :current_password

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def is_following?(user)
    followings.find_by(id: user.id).present?
  end
end
