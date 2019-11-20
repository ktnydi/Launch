class UsersController < ApplicationController
  def show
    if @user = User.find_by(uuid: params[:id])
      @entries = @user.entries.publics.new_order.page(params[:page]).per(20)
      @tags = @user.entries.tag_ranking.take(5)
    end
  end
end
