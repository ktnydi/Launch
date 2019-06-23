class PublicsController < ApplicationController
  def index
  end

  def show
    @public = Public.find_by(article_token: params[:article_token])
  end

  def create
    @public = Public.new(public_params)
    @public.user_token = current_user.uuid
    if @public.save
      render json: @public
    else
      render json: @public.errors.full_messages
    end
  end

  def update
  end

  def destroy
  end

  :private
    def public_params
      params.require(:public).permit(:article_token, :title, :category, :content)
    end
end
