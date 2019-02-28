class FollowsController < ApplicationController
  def create
    @follow = current_user.active_follows.create(
              followed_user_id: params[:user_id]
              )
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @follow = current_user.active_follows.find_by(followed_user_id: params[:user_id])
    @follow.destroy
    redirect_back(fallback_location: root_path)
  end
end
