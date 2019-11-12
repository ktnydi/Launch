class BookmarksController < ApplicationController
  before_action :authenticate_user!

  def index
    @entries = current_user.bookmarked_entries.page(params[:page]).per(20)
  end

  def create
    bookmark = current_user.bookmarks.new(entry_token: params[:entry_token])
    if bookmark.save
      render json: bookmark, status: :created
    else
      render json: bookmark.errors, status: :unprocessable_entity
    end
  end

  def destroy
    bookmark = current_user.bookmarks.find_by(entry_token: params[:entry_token])
    if bookmark.destroy
      head :no_content
    else
      render json: bookmark.errors, status: :unprocessable_entity
    end
  end
end
