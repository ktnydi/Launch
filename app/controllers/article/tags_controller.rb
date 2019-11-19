class Article::TagsController < ApplicationController
  def show
    @entries = Entry.publics.where("tags LIKE ?", "%#{params[:category]}%").order("created_at DESC").page(params[:page]).per(20)
    @tags = Entry.tag_ranking.take(10)
    redirect_to root_path unless @entries.length > 0
  end
end
