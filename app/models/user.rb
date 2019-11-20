class User < ApplicationRecord
  require "securerandom"
  self.primary_key = "uuid"

  has_one :image, foreign_key: "user_token",dependent: :destroy
  has_many :drafts, foreign_key: "user_token", dependent: :destroy
  has_many :publics, foreign_key: "user_token", dependent: :destroy
  has_many :entries, foreign_key: "user_token", dependent: :destroy
  has_many :comments, foreign_key: "user_token", dependent: :destroy
  has_many :likes, foreign_key: "user_token", dependent: :destroy
  has_many :liked_entries, through: :likes, source: :entry
  has_many :bookmarks, foreign_key: "user_token", dependent: :destroy
  has_many :bookmarked_entries, through: :bookmarks, source: :entry
  has_many :access_analyses, foreign_key: "user_token", dependent: :destroy
  has_many :history_entries, through: :access_analyses, source: :entry
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

  def liked?(entry)
    !!likes.find_by(entry_token: entry.token)
  end

  def add_like_count(entry)
    unless self.liked?(entry)
      return 0
    end

    like = self.likes.find_by(entry_token: entry.token)
    like.count
  end

  def bookmarked?(entry)
    !!bookmarks.find_by(entry_token: entry.token)
  end

  def is_following?(user)
    followings.find_by(uuid: user.uuid).present?
  end

  def liked_article?(article)
    liked_article.find_by(article_token: article.article_token)
  end

  def all_pv_count
    self.entries.sum(:pv)
  end

  def day_pv_count
    entries = self.entries
    AccessAnalysis.where(entry_token: entries.pluck(:token)).where("created_at > ?", Time.current.beginning_of_day).count
  end

  def week_pv_count
    entries = self.entries
    AccessAnalysis.where(entry_token: entries.pluck(:token)).where("created_at > ?", Time.current.beginning_of_week).count
  end

  def month_pv_count
    entries = self.entries
    AccessAnalysis.where(entry_token: entries.pluck(:token)).where("created_at > ?", Time.current.beginning_of_month).count
  end

  def chart_data
    entries = self.entries
    pv_per_day = AccessAnalysis.where(entry_token: entries.pluck(:token)).where("created_at > ?", 30.day.ago.beginning_of_day)
      .select("date(created_at)")
      .group("date(created_at)")
      .count("date(created_at)")
      .map{|date, pv| [date.strftime("%m/%d"), pv]}
      .to_h
    chart_data = {}
    30.downto(0).each do |i|
      day = i.day.ago.beginning_of_day.strftime("%m/%d")
      pv = pv_per_day[day]
      chart_data[day] = pv || 0
    end
    chart_data
  end

  def popular_entries(from_date: 1.day.ago)
    entries = self.entries
    popular_entry_tokens = AccessAnalysis
      .where("created_at > ?", from_date)
      .where(entry_token: entries.pluck(:token))
      .select("entry_token, count(entry_token) as pv")
      .group(:entry_token)
      .order("pv desc")
      .map(&:entry_token)
    return unless popular_entry_tokens.length > 0
    popular_entries = entries.where(token: popular_entry_tokens).sort_by{ |o| popular_entry_tokens.index(o.id)}
    popular_entries
  end

  def access_sources(from_date: 1.day.ago)
    entries = self.entries
    access_sources = AccessAnalysis
      .where("created_at > ?", from_date)
      .where(entry_token: entries.pluck(:token))
      .select("access_source, count(access_source) as count")
      .group(:access_source)
      .order("count desc")
  end

  def create_uuid
    self.uuid = SecureRandom.hex(10) if self.uuid.empty?
  end

  def create_image
    image = self.build_image(filename: "", file: "")
    image.save
  end
end
