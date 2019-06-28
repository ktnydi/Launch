class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show]
  before_action :forbiden_access, only: [:show]

  def index
    @publics = Public.all.order(created_at: :desc).limit(5)
  end

  def show
    @user = User.find_by(uuid: params[:id])
    if @publics = @user.publics.search(params[:pq]).page(params[:page]).per(10)
      respond_to do |format|
        format.js
        format.html
      end
    else
      @publics = @user.publics.order(created_at: :desc).page(params[:page]).per(10)
    end
    @drafts = @user.drafts.order(created_at: :desc).page(params[:page]).per(10)
  end

  private

  def forbiden_access
    if current_user.uuid != params[:id]
      flash[:alert] = "このアクセスは禁止されています。"
      redirect_to users_path
    end
  end
end
