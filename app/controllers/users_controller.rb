class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :forbiden_access

  def show
    @user = User.find_by(id: params[:id])
    @posts = @user.posts.order(created_at: :desc).page(params[:page]).per(5)
    if params[:q]
      @posts = @user.posts.search(params[:q]).page(params[:page]).per(5)
    end
    @count = 0
    @user.posts.each do |post|
      @count += post.impressions_count
    end
    @liked_posts = @user.liked_posts.status_public.order(created_at: :desc).limit(10)
  end

  private

  def forbiden_access
    if current_user.id != params[:id].to_i
      flash[:alert] = "このアクセスは禁止されています。"
      redirect_to root_path
    end
  end
end
