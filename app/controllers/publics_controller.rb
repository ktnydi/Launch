class PublicsController < ApplicationController
  require 'securerandom'
  before_action :create_access_analysis, only: [:show]
  def index
    @publics = Public.all.order(created_at: :desc).page(params[:page]).per(20)
    if params[:q]
      @publics = Public.all.search(params[:q]).page(params[:page]).per(20)
    end
  end

  def show
    @public = Public.find_by(article_token: params[:article_token])
    @comment = Comment.new
  end

  def create
    @public = Public.new(public_params)
    unless @public.article_token.present?
      @public.article_token = SecureRandom.hex(10)
    end
    @public.user_token = current_user.uuid
    if @public.save
      draft = Draft.find_by(article_token: @public.article_token)
      draft&.destroy
      render json: { url: dashboard_article_path + '?mode=public' }
    else
      render json: @public.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    @public = Public.find_by(article_token: params[:article_token])
    if @public.destroy
      redirect_to user_path(current_user)
    end
  end

  def tag
    @publics = Public.where("category LIKE ?", "%#{params[:category]}%").order("created_at DESC").page(params[:page]).per(20)
    if @publics.count < 1
      redirect_to root_path
    end
  end

  def history
    @history_publics = Public.joins(:access_analyses)
                             .select("publics.*, max(access_analyses.created_at) as last_access_time")
                             .where("access_analyses.user_token = ?", current_user.uuid)
                             .group("access_analyses.article_token")
                             .order("last_access_time desc")
                             .limit(40)
                             .page(params[:page])
                             .per(20)
  end

  def good
    @good_articles = current_user.liked_article.page(params[:page]).per(20)
  end

  :private
    def public_params
      params.require(:public).permit(:article_token, :title, :category, :content)
    end

    def create_access_analysis
      access_analysis = AccessAnalysis.create(
        article_token: params[:article_token],
        access_source: request.referer,
        user_token: current_user&.uuid || ""
      )
    end
end
