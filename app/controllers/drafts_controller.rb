class DraftsController < ApplicationController
  require 'securerandom'
  before_action :authenticate_user!

  def show
    @draft = Draft.find_by(article_token: params[:article_token])
  end

  def new
    @draft = Draft.new
    render layout: "editor"
  end

  def create
    @draft = Draft.new(draft_params)
    @draft.article_token = SecureRandom.hex(10)
    @draft.user_token = current_user.uuid
    if @draft.save
      render json: { url: dashboard_article_path }
    else
      render json: @draft.errors.full_messages, status: :unprocessable_entity
    end
  end

  def edit
    @draft = Draft.find_by(article_token: params[:article_token])
    render layout: "editor"
  end

  def update
    @draft = Draft.find_by(article_token: params[:article_token])
    @draft.assign_attributes(draft_params)
    if @draft.save
      render json: { url: dashboard_article_path }
    else
      render json: @draft.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    @draft = Draft.find_by(article_token: params[:article_token])
    if @draft.destroy
      redirect_to dashboard_article_path + "?mode=draft"
    end
  end

  :private
    def draft_params
      params.require(:draft).permit(:title, :category, :content)
    end
end
