class FollowsController < ApplicationController
  before_action :user

  def create
    @follow = current_user.active_follows.create(
              followed_user_id: params[:user_id]
              )
    respond_to do |format|
      if @follow
        format.js
        format.html
      end
    end
  end

  def destroy
    @follow = current_user.active_follows.find_by(
              followed_user_id: params[:user_id]
              )
    respond_to do |format|
      if @follow.destroy
        format.js
        format.html
      end
    end

  end

  def follow
    @user = User.find_by(uuid: params[:user_id])
    @followings = @user.followings.page(params[:page]).per(80)
  end

  def follower
    @user = User.find_by(uuid: params[:user_id])
    @followers = @user.followers.page(params[:page]).per(80)
  end

  private
    def user
      @user = User.find_by(uuid: params[:user_id])
    end
end
