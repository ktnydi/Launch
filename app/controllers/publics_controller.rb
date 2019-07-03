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
      render json: @public
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
