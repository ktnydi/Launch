class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show]
  before_action :get_trend_articles, only: [:index]
  before_action :get_trend_article_sources_with_current_user, only: [:show]
  before_action :current_user_article_comment, only: [:show]

  def index
    @publics = Public.all.order(created_at: :desc).limit(5)
  end

  def show
    @user = User.find_by(uuid: current_user.uuid)
    if @publics = @user.publics.search(params[:pq]).page(params[:page]).per(10)
      respond_to do |format|
        format.js
        format.html
      end
    else
      @publics = @user.publics.order(created_at: :desc).page(params[:page]).per(10)
    end
    @drafts = @user.drafts.order(created_at: :desc).page(params[:page]).per(10)

    article_tokens = current_user.publics.pluck(:article_token)
    # { "YYYY-mm-dd" => access_count }
    count_by_created_at = AccessAnalysis.where(article_token: article_tokens).where("created_at > ?", 29.day.ago.beginning_of_day).select("date(created_at)").group("date(created_at)").count("date(created_at)")

    @last_week = {}
    29.downto(0).each do |i|
      day = i.day.ago.beginning_of_day
      if access_count = count_by_created_at[day.strftime("%Y-%m-%d")]
        @last_week[day.strftime("%m/%d")] = access_count
      else
        @last_week[day.strftime("%m/%d")] = 0
      end
    end

    respond_to do |format|
      if params[:mode]
        format.js if params[:mode] == "draft"
        format.js if params[:mode] == "public"
      end
      format.json { render json: @last_week }
      format.html
    end
  end

  private

  def current_user_article_comment
    article_tokens = current_user.publics.pluck(:article_token)
    @comments = Comment.where(article_token: article_tokens).order("created_at DESC")
  end

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

  def get_trend_article_sources_with_current_user
    @trend_articles = []
    access_analyses.each do |key, _|
      article = Public.find_by(article_token: key)
      @trend_articles << article
    end

    # [ {"id"=>nil, "access_source"=>"http://sample.com", "access_count"=>123 } ]
    @access_analyses = @trend_articles.first.access_analyses.select("count(access_source) as count, access_source as source").group(:access_source)
  end

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
