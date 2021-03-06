class Public < ApplicationRecord
  include Search
  self.primary_key = "article_token"
  serialize :category

  has_many :likes, foreign_key: "article_token" ,dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  has_many :bookmarks, foreign_key: "article_token", dependent: :destroy
  has_many :bookmark_users, through: :bookmarks, source: :user
  has_many :comments, foreign_key: "article_token", dependent: :destroy
  has_many :access_analyses, foreign_key: "article_token", dependent: :destroy
  belongs_to :user, foreign_key: "user_token"

  validates :article_token, presence: true, uniqueness: true
  validates :title, presence: true, length: { maximum: 50 }
  validates :category, presence: true, length: { maximum: 20 }
  validates :content, presence: true, length: { maximum: 10000 }
  validates :user_token, presence: true

  before_save :category_to_hash

  scope :history_articles, -> (current_user) do
    joins(:access_analyses)
      .select("publics.*, max(access_analyses.created_at) as last_access_time")
      .where("access_analyses.user_token = ?", current_user.uuid)
      .group("publics.id, access_analyses.article_token")
      .order("last_access_time desc")
      .limit(40)
  end

  scope :get_trend_articles, -> (period = "") do
    joins(:access_analyses)
      .select("publics.*, count(access_analyses.article_token) as count")
      .where("access_analyses.created_at > ?", 29.days.ago)
      .group("publics.id, access_analyses.article_token")
      .order("count DESC")
  end

  scope :get_same_tag_articles, -> (article) do
    tag = article.category.split(",").first
    current_article_token = article.article_token
    self.where("category LIKE ?", "%#{tag}%").where.not(article_token: current_article_token).order(created_at: :desc)
  end

  scope :all_tags, -> (arg = {}) do
    rel = arg.length > 0 ? self.where(arg) : self.all
    rel.pluck(:category).flatten
  end

  scope :tag_ranking, -> (arg = {}) do
    rel = arg.length > 0 ? all_tags.uniq : all_tags(arg).uniq
    tag_ranking = rel.map do |tag_name|
      [tag_name, all_tags.count(tag_name)]
    end
    tag_ranking.sort_by(&:last).reverse[0..10].map do |tag|
      {name: tag[0], count: tag[1]}
    end
  end

  private
    def category_to_hash
      self.category = self.category.split(",")
    end
end
