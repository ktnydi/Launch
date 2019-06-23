class PublicsController < ApplicationController
  require 'securerandom'
  def index
  end

  def show
    @public = Public.find_by(article_token: params[:article_token])
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
end
