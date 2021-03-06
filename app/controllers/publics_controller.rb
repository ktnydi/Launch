class PublicsController < ApplicationController
  require 'securerandom'
  before_action :authenticate_user!, only: [:create, :history, :good]
  before_action :set_public, only: [:show]
  before_action :confirm_params, only: [:show]
  before_action :create_access_analysis, only: [:show]

  def index
    @publics = Public.all.order(created_at: :desc).page(params[:page]).per(20)
    if params[:q]
      @publics = Public.all.search(params[:q]).page(params[:page]).per(20)
    end
  end

  def show
    @comment = Comment.new
  end

  def create
    @public = current_user.publics.new(public_params)
    @public.article_token = SecureRandom.hex(10) unless @public.article_token.present?
    if @public.save
      if draft = Draft.find_by(article_token: @public.article_token)
        draft.destroy
      end

      render json: { url: dashboard_article_path + '?mode=public' }
    else
      render json: @public.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    @publics = Public.where(article_token: params[:article_ids])
    @publics.delete_all
  end

  :private
    def set_public
      @public = Public.find_by(article_token: params[:article_token])
    end

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

    def confirm_params
      unless Public.find_by(article_token: params[:article_token])
        redirect_to root_path
      end
    end
end
