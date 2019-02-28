class LikesController < ApplicationController
  before_action :authenticate_user!
  def index
    @posts = current_user.liked_posts.order(created_at: :desc).page(params[:page]).per(30)
  end

  def create
    @like = current_user.likes.create(post_id: params[:post_id])
    redirect_to post_path(params[:post_id])
  end

  def destroy
    @like = current_user.likes.find_by(post_id: params[:post_id])
    @like.destroy
    redirect_to post_path(params[:post_id])
  end
end
