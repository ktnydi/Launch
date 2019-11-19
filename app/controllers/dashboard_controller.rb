class DashboardController < ApplicationController
  before_action :authenticate_user!

  layout "application_dashboard"

  def index
    gon.chart_data = current_user.chart_data
    @popular_entries = current_user.popular_entries(from_date: Time.current.beginning_of_week)
    @access_sources = current_user.access_sources(from_date: Time.current.beginning_of_week)
  end

  def article
    @articles = params[:mode] == "public" ? current_user.publics : current_user.drafts
    @articles = @articles.search(params[:q]).page(params[:page]).per(10)

    respond_to do |format|
      format.js
      format.html
    end
  end

  def comment
    article_tokens = current_user.publics.pluck(:article_token)
    @comments = Comment.where(article_token: article_tokens).order("created_at DESC").page(params[:page]).per(10)
  end
end
