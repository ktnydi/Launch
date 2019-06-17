class User < ApplicationRecord
  require "securerandom"
  self.primary_key = "uuid"

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
  before_validation :create_uuid

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable
  include Gravtastic
  gravtastic

  def self.find_for_oauth(auth)
    user = User.where(uid: auth.uid, provider: auth.provider).first

    unless user
      user = User.create(
        uid: auth.uid,
        provider: auth.provider,
        email: User.dummy_email(auth),
        password: Devise.friendly_token[0, 20],
        name: auth.info.name,
        nickname: auth.info.nickname
      )
    end

    user
  end

  def self.dummy_email(auth)
    "#{auth.uid}-#{auth.provider}@example.com"
  end

  def is_following?(user)
    followings.find_by(uuid: user.uuid).present?
  end

  def create_uuid
    self.uuid = SecureRandom.hex(10) if self.uuid.empty?
  end
end
