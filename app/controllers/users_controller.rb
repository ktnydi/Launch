class UsersController < ApplicationController
  before_action :get_trend_articles, only: [:index]

  def index
    @publics = Public.all.order(created_at: :desc).limit(5)
  end

  private

  def get_trend_articles
    period = case params[:period]
             when "week"
               1.week.ago
             when "month"
               1.month.ago
             else
               1.day.ago
             end

    # [ {"article_token"=>"8ffbra92g....", "access_count"=>123}, .....]
    trends = AccessAnalysis.find_by_sql(
      ["SELECT COUNT(article_token) AS access_count, article_token
       FROM access_analyses
       WHERE created_at > ?
       GROUP BY article_token
       ORDER BY access_count DESC",
       period]
    )

    @trend_articles = trends.map do |trend|
      Public.find_by(article_token: trend.article_token)
    end
  end
end
