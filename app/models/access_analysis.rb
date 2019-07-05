class AccessAnalysis < ApplicationRecord
  belongs_to :public, foreign_key: "article_token"
end
