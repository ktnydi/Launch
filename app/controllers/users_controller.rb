class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :forbiden_access

  def show
    @user = User.find_by(id: params[:id])
  end

  private

  def forbiden_access
    if current_user.id != params[:id].to_i
      flash[:alert] = "このアクセスは禁止されています。"
      redirect_to root_path
    end
  end
end
