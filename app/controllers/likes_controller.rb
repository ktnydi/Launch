class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :post, except: [:index]

  def index
    @posts = current_user.liked_posts.status_public.order(created_at: :desc).page(params[:page]).per(30)
  end

  def create
    @like = current_user.likes.create(post_id: params[:post_uuid])
    respond_to do |format|
      if @like
        format.js
        format.html
      end
    end
  end

  def destroy
    @like = current_user.likes.find_by(post_id: params[:post_uuid])
    respond_to do |format|
      if @like.destroy
        format.js
        format.html
      end
    end
  end

  private
    def post
      @post = Post.find_by(uuid: params[:post_uuid])
    end
end
