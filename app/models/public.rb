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

  scope :all_tags, -> do
    self.all.pluck(:category).flatten
  end

  scope :tag_count, -> (tag_name) do
    all_tags.count(tag_name)
  end

  scope :tag_ranking, -> (num = 1) do
    tag_ranking = all_tags.uniq.map do |tag_name|
      [tag_name, tag_count(tag_name)]
    end
    tag_ranking.sort_by(&:last).reverse[0..(num - 1)].to_h
  end

  private
    def category_to_hash
      self.category = self.category.split(",")
    end
end
