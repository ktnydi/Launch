class AccessAnalysis < ApplicationRecord
  belongs_to :public, foreign_key: "article_token", counter_cache: true

  scope :access_within_date_range, -> (beginning_of_date) do
    where("created_at > ?", beginning_of_date)
    .select("date(created_at)")
    .group("date(created_at)")
    .count("date(created_at)")
  end
end
