class Public < ApplicationRecord
  self.primary_key = "article_token"

  has_many :likes, foreign_key: "article_token" ,dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  has_many :comments, foreign_key: "article_token", dependent: :destroy
  belongs_to :user, foreign_key: "user_token"

  validates :article_token, presence: true, uniqueness: true
  validates :title, presence: true, length: { maximum: 50 }
  validates :category, presence: true, length: { maximum: 20 }
  validates :content, presence: true, length: { maximum: 10000 }
  validates :user_token, presence: true

  def like_user(user_token)
    likes.find_by(user_token: user_token)
  end

  def self.search(query)
    rel = order(created_at: :desc)
    if query.present?
      rel = rel.where("title LIKE ?", "%#{query}%")
    end
    rel
  end

  def self.get_tags
    tags_list = self.all.map do |article|
      article.category.split(',')
    end

    tags_list.flatten.uniq
  end

  def self.get_article_include_tag(name)
    articles = []
    self.all.order(created_at: :desc).each do |article|
      tag_list = article.category.split(",")
      if tag_list.include?(name)
        articles << article
      end
    end
    articles[0..2]
  end

  def self.tag_ranking
    tags_list = self.all.map do |article|
      article.category.split(',')
    end

    tag_ranking = {}
    tags_list.flatten.uniq.each do |tag_name|
      tag_ranking[tag_name] = tags_list.flatten.count(tag_name)
    end
    tag_ranking.sort_by{ |key, value| value }.reverse[0..2].to_h
  end
end