class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :post

  def index
    @likes = current_user.liked_article.page(params[:page]).per(20)
  end

  def create
    @like = current_user && current_user.likes.new(article_token: params[:article_token])
    respond_to do |format|
      if @like.save
        format.js
        format.html
      end
    end
  end

  def destroy
    @like = current_user.likes.find_by(article_token: params[:article_token])
    respond_to do |format|
      if @like.destroy
        format.js
        format.html
      end
    end
  end

  private
    def post
      @public = Public.find_by(article_token: params[:article_token])
    end
end
