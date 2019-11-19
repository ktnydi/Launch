class Entry < ApplicationRecord
  self.primary_key = "token"
  serialize :tags

  has_many :bookmarks, foreign_key: "entry_token", dependent: :destroy
  has_many :likes, foreign_key: "entry_token", dependent: :destroy
  has_many :comments, foreign_key: "entry_token", dependent: :destroy
  belongs_to :user, foreign_key: "user_token"

  validates :title, presence: true, length: { maximum: 50 }
  validates :tags, length: { maximum: 50 }
  validates :content, length: { maximum: 10000 }

  has_secure_token :token

  scope :publics, -> { self.where(status: 1) }
  scope :new_order, -> { self.order(created_at: :desc) }
  scope :search, -> (query) do
    self.where("title LIKE ? OR tags LIKE ?", "%#{query}%", "%#{query}%")
  end

  def self.trend(from_date: 1.day.ago)
    publics = self.publics
    trend_entry_tokens = AccessAnalysis
      .where("created_at > ?", from_date)
      .select("entry_token, count(entry_token) as pv")
      .group(:entry_token)
      .order("pv desc")
      .map(&:entry_token)
    unless trend_entry_tokens.length > 0
      return
    end
    trend_entries = publics.where(token: trend_entry_tokens).sort_by{ |o| trend_entry_tokens.index(o.id)}
    trend_entries
  end

  def self.tag_ranking
    tags = self.publics.pluck(:tags).flatten
    tags.group_by(&:to_s).sort_by{|_,v|-v.size}.map(&:first)
  end

  before_save :tags_to_array

  :private
    def tags_to_array
      self.tags = self.tags.split(",")
    end
end
