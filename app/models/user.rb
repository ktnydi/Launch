class User < ApplicationRecord
  require "securerandom"
  self.primary_key = "uuid"

  has_one :image, foreign_key: "user_token",dependent: :destroy
  has_many :drafts, foreign_key: "user_token", dependent: :destroy
  has_many :publics, foreign_key: "user_token", dependent: :destroy
  has_many :entries, foreign_key: "user_token", dependent: :destroy
  has_many :comments, foreign_key: "user_token", dependent: :destroy
  has_many :likes, foreign_key: "user_token", dependent: :destroy
  has_many :liked_article, through: :likes, source: :public
  has_many :bookmarks, foreign_key: "user_token", dependent: :destroy
  has_many :bookmark_articles, through: :bookmarks, source: :public
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
  after_create :create_image

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

  def author?(entry)
    self.entries.find_by(token: entry.token)
  end

  def is_following?(user)
    followings.find_by(uuid: user.uuid).present?
  end

  def liked_article?(article)
    liked_article.find_by(article_token: article.article_token)
  end

  def create_uuid
    self.uuid = SecureRandom.hex(10) if self.uuid.empty?
  end

  def create_image
    image = self.build_image(filename: "", file: "")
    image.save
  end
end
