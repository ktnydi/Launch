class Article::HistoryController < ApplicationController
  def index
    @history_publics = Public.history_articles(current_user).page(params[:page]).per(20)
  end
end
