class HomeController < ApplicationController
  def index
    if params[:user_id]
      @user = User.find_by(id: params[:user_id])
    else
      @user = current_user
    end

    if @user
      @followings = @user.followings
      @following_ids = [current_user.id]
      @followings.each do |following|
        @following_ids << following.id
      end
      @following_posts = Post.status_public
                             .where(user_id: @following_ids)
                             .order(created_at: :desc)
                             .page(params[:page])
                             .per(20)
    end

    posts_for(params[:period])
  end

  private
  def posts_ranking(period)
    @posts = Post.status_public.where("created_at > ?", period).order(impressions_count: :desc).limit(5)
  end

  def posts_for(param)
    today = 1.day.ago
    week  = 1.week.ago
    month = 1.month.ago
    if param
      case param
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
end
