class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show]
  before_action :forbiden_access, only: [:show]
  before_action :get_trend_articles, only: [:index]

  def index
    @publics = Public.all.order(created_at: :desc).limit(5)
  end

  def show
    @user = User.find_by(uuid: params[:id])
    if @publics = @user.publics.search(params[:pq]).page(params[:page]).per(10)
      respond_to do |format|
        format.js
        format.html
      end
    else
      @publics = @user.publics.order(created_at: :desc).page(params[:page]).per(10)
    end
    @drafts = @user.drafts.order(created_at: :desc).page(params[:page]).per(10)
  end

  private

  def forbiden_access
    if current_user.uuid != params[:id]
      flash[:alert] = "このアクセスは禁止されています。"
      redirect_to users_path
    end
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
