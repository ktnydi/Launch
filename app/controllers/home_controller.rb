class HomeController < ApplicationController
  before_action :get_trend_articles, only: [:index]

  def index
    @publics = Public.all.order(created_at: :desc).limit(5)
  end

  private
    def get_trend_articles
      @trend_articles = Public.get_trend_articles(date(params[:period])).limit(10)
    end
end
