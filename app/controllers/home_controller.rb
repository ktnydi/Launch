class HomeController < ApplicationController
  def index
    today = 1.day.ago
    week  = 1.week.ago
    month = 1.month.ago
    if params[:period]
      case params[:period]
      when "today"
        posts_ranking today
      when "week"
        posts_ranking week
      when "month"
        posts_ranking month
      end
    else
      posts_ranking today
    end
  end

  private
  def posts_ranking(period)
    @posts = Post.where("created_at > ?", period).order(impressions_count: :desc).limit(10)
  end
end
