class LikesController < ApplicationController
  before_action :authenticate_user!

  def index
    @likes = current_user.liked_entries.page(params[:page]).per(20)
  end

  def create
    like = current_user.likes.new(entry_token: params[:entry_token], count: params[:count])
    if like.save
      render json: like, status: :created
    else
      render json: like.errors, status: :unprocessable_entity
    end
  end

  def update
    like = current_user.likes.find_by(entry_token: params[:entry_token])
    if like.update_attributes(count: params[:count])
      render json: like, status: :ok
    else
      render json: like.errors, status: :unprocessable_entity
    end
  end

  def destroy
    like = current_user.likes.find_by(entry_token: params[:entry_token])
    if like.destroy
      head :no_content
    else
      render like.errors, status: :unprocessable_entity
    end
  end
end
