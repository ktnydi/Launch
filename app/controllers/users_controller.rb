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
      @posts = Post.status_public
                             .where(user_id: @following_ids)
                             .order(created_at: :desc)
                             .page(params[:page])
                             .per(20)
    end
  end

  def show
    @user = User.find_by(uuid: params[:id])
    @posts = @user.posts.order(created_at: :desc).page(params[:page]).per(5)
    if params[:q]
      @posts = @user.posts.search(params[:q]).page(params[:page]).per(5)
    end
    @count = 0
    @liked_posts = @user.liked_posts.status_public.order(created_at: :desc).limit(10)
  end

  private

  def forbiden_access
    if current_user.uuid != params[:id]
      flash[:alert] = "このアクセスは禁止されています。"
      redirect_to users_path
    end
  end
end
