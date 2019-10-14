class UsersController < ApplicationController
  def show
    if @user = User.find_by(uuid: params[:id])
      @articles = Public.where(user_token: @user.uuid).order(created_at: :desc).page(params[:page]).per(20)
    end
  end
end
