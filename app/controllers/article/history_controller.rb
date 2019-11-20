class Article::HistoryController < ApplicationController
  def index
    @entries = current_user.history_entries.page(params[:page]).per(20)
  end
end
