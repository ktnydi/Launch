class BookmarksController < ApplicationController
  before_action :get_public
  before_action :authenticate_user!

  def index
    @bookmark_publics = current_user.bookmark_articles.page(params[:page]).per(20)
  end

  def create
    bookmark = current_user.bookmarks.new(article_token: params[:public_article_token])
    if bookmark.save
      respond_to do |format|
        format.js { render 'bookmark' }
        format.html
      end
    end
  end

  def destroy
    bookmark = current_user.bookmarks.find_by(article_token: params[:public_article_token])
    if bookmark.destroy
      respond_to do |format|
        format.js { render 'bookmark' }
        format.html
      end
    end
  end

  private
    def get_public
      @public = Public.find_by(article_token: params[:public_article_token])
    end
end
