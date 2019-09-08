class Article::TagsController < ApplicationController
  def show
    @publics = Public.where("category LIKE ?", "%#{params[:category]}%").order("created_at DESC").page(params[:page]).per(20)
    redirect_to root_path unless @publics.length > 0
  end
end
