class BookmarksController < ApplicationController
  def create
    bookmark = current_user.Bookmark.new(bookmark_params)
    if bookmark.save
      respond_to do |format|
        format.js
        format.html
      end
    end
  end

  def destroy
    bookmark = current_user.bookmarks.find_by(article_token: params[:article_token])
    if bookmark.destroy
      respond_to do |format|
        format.js
        format.html
      end
    end
  end

  private
    def bookmark_params
      params.require(:bookmark).permit(:article_token)
    end
end
