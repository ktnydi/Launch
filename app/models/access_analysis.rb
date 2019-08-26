class AccessAnalysis < ApplicationRecord
  belongs_to :public, foreign_key: "article_token", counter_cache: true

  scope :access_within_date_range, -> (beginning_of_date) do
    where("created_at > ?", beginning_of_date)
    .select("date(created_at)")
    .group("date(created_at)")
    .count("date(created_at)")
  end

  scope :joins_public, -> {
    joins(:public).select("publics.*, access_analyses.*")
  }

  scope :since, -> (period) {
    where("access_analyses.created_at > ?", period)
  }

  scope :many_access_articles_since, -> (period) {
    joins_public
      .since(period)
      .group("publics.id, access_analyses.article_token")
      .select("count(access_analyses.article_token) as pv")
      .order("pv DESC")
  }

  scope :article_source_of, -> (article_token) {
    where(article_token: article_token)
      .group(:access_source)
      .select("access_source, count(access_source) as pv")
      .order("pv DESC")
  }
end
