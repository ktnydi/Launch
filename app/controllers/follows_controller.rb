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

  def follow
    @user = User.find_by(id: params[:user_id])
    @followings = @user.followings.page(params[:page]).per(80)
  end

  def follower
    @user = User.find_by(id: params[:user_id])
    @followers = @user.followers.page(params[:page]).per(80)
  end
end
