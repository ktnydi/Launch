class DashboardController < ApplicationController
  before_action :authenticate_user!, only: [:index]
  before_action :get_trend_article_sources_with_current_user, only: [:index]

  layout "application_dashboard"

  def index
    # acategory : analytics
    article_tokens = current_user.publics.pluck(:article_token)
    # { "YYYY-mm-dd" => access_count }
    count_by_created_at = AccessAnalysis.where(article_token: article_tokens).where("created_at > ?", 29.day.ago.beginning_of_day).select("date(created_at)").group("date(created_at)").count("date(created_at)")

    last_month = {}
    29.downto(0).each do |i|
      day = i.day.ago.beginning_of_day
      if access_count = count_by_created_at[day.strftime("%Y-%m-%d")]
        last_month[day.strftime("%m/%d")] = access_count
      else
        last_month[day.strftime("%m/%d")] = 0
      end
    end

    respond_to do |format|
      format.js { render json: last_month }
      format.html
    end

  end

  def article
    if params[:mode] == "public"
      @articles = current_user.publics.search(params[:q]).page(params[:page]).per(10)
    else
      @articles = current_user.drafts.search(params[:q]).page(params[:page]).per(10)
    end

    respond_to do |format|
      format.js
      format.html
    end
  end

  def comment
    article_tokens = current_user.publics.pluck(:article_token)
    @comments = Comment.where(article_token: article_tokens).order("created_at DESC").page(params[:page]).per(10)
  end

  private

  # category : analytics
  def access_analyses(period = "")
    # current_userが投稿した記事
    article_tokens = current_user.publics.pluck(:article_token)

    period = case params[:period]
      when "day"
        1.day.ago.beginning_of_day
      when "week"
        1.week.ago.beginning_of_week
      when "month"
        1.month.ago.beginning_of_month
      else
        ""
      end

    # { article_token => access_count }
    AccessAnalysis.where(article_token: article_tokens)
                  .where("created_at > ?", period)
                  .group(:article_token)
                  .order("count_article_token DESC")
                  .count(:article_token)
  end

  # category : analytics
  def get_trend_article_sources_with_current_user
    @trend_articles = []
    access_analyses.each do |key, _|
      article = Public.find_by(article_token: key)
      @trend_articles << article
    end

    # [ {"id"=>nil, "access_source"=>"http://sample.com", "access_count"=>123 } ]
    @access_analyses = @trend_articles.first.access_analyses.select("count(access_source) as count, access_source as source").group(:access_source)
  end
end