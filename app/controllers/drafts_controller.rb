class DraftsController < ApplicationController
  require 'securerandom'
  before_action :authenticate_user!
  before_action :set_draft, only: [:edit, :update, :destroy]

  def new
    @draft = Draft.new
    render layout: "editor"
  end

  def create
    @draft = current_user.drafts.new(draft_params)
    @draft.article_token = SecureRandom.hex(10)
    if @draft.save
      render json: { url: dashboard_article_path + "?mode=draft" }
    else
      render json: @draft.errors.full_messages, status: :unprocessable_entity
    end
  end

  def edit
    render layout: "editor"
  end

  def update
    @draft.assign_attributes(draft_params)
    if @draft.save
      render json: { url: dashboard_article_path }
    else
      render json: @draft.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    if @draft.destroy
      redirect_to dashboard_article_path + "?mode=draft"
    end
  end

  def multiple_destroy
    @drafts = Draft.where(article_token: params[:article_ids])
    @drafts.delete_all
  end

  :private
    def set_draft
      @draft = Draft.find_by(article_token: params[:article_token])
    end

    def draft_params
      params.require(:draft).permit(:title, :category, :content)
    end
end
