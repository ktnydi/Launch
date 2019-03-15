class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show]
  before_action :forbiden_access, only: [:show]

  def index
    if params[:user_id]
      @user = User.find_by(uuid: params[:user_id])
    else
      @user = current_user
    end

    if @user
      @followings = @user.followings
      @following_ids = [@user.uuid]
      @followings.each do |following|
        @following_ids << following.uuid
      end
      @following_posts = Post.status_public
                             .where(user_id: @following_ids)
                             .order(created_at: :desc)
                             .page(params[:page])
                             .per(20)
    else
      redirect_to root_path
    end
    posts_for(params[:period])
  end

  def show
    @user = User.find_by(uuid: params[:id])
    @posts = @user.posts.order(created_at: :desc).page(params[:page]).per(5)
    if params[:q]
      @posts = @user.posts.search(params[:q]).page(params[:page]).per(5)
    end
    @count = 0
    @posts.each do |post|
      @count += post.counts.length
    end
    @liked_posts = @user.liked_posts.status_public.order(created_at: :desc).limit(10)
  end

  private

  def forbiden_access
    if current_user.uuid != params[:id]
      flash[:alert] = "このアクセスは禁止されています。"
      redirect_to users_path
    end
  end

  def posts_ranking(period)
    count_access = Count.where("created_at > ?", period).limit(5).group("post_id").count("post_id")
    sort_access = count_access.sort{ |(key1, val1), (key2, val2)| val2 <=> val1 }.to_h  #=> {"post_id" => count}
    @posts = []
    sort_access.each_key do |key|
      @posts << Post.find_by(uuid: key)
    end

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
