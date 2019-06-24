class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show]
  before_action :forbiden_access, only: [:show]

  def index
    @user = params[:user_id] ? User.find_by(uuid: params[:user_id]) : current_user

    if @user
      @followings = @user.followings
      @following_ids = [@user.uuid]
      @followings.each do |following|
        @following_ids << following.uuid
      end
      if params[:article]
        @publics = @user.liked_article.order(created_at: :desc).page(params[:page]).per(20)
      else
        @publics = Public.where(user_token: @following_ids)
                        .order(created_at: :desc)
                        .page(params[:page])
                        .per(20)
      end
    else
      redirect_to posts_path
    end
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
  end

  private

  def forbiden_access
    if current_user.uuid != params[:id]
      flash[:alert] = "このアクセスは禁止されています。"
      redirect_to users_path
    end
  end
end
