class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :post

  def create
    @like = current_user && current_user.likes.new(article_token: params[:public_article_token])
    respond_to do |format|
      if @like.save
        format.js
        format.html
      else
        p @like.errors.full_messages
        flash[:alert] = "いいねするにはログインが必要です。"
        format.js { render js: "window.location = '#{new_user_session_path}';" }
      end
    end
  end

  def destroy
    @like = current_user.likes.find_by(article_token: params[:public_article_token])
    respond_to do |format|
      if @like.destroy
        format.js
        format.html
      end
    end
  end

  private
    def post
      @public = Public.find_by(article_token: params[:public_article_token])
    end
end
