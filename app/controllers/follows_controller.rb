class FollowsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def create
    @follow = current_user.active_follows.create(
              followed_user_id: params[:user_id]
              )
    respond_to do |format|
      if @follow
        format.js { render 'follow'}
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
        format.js { render 'follow' }
        format.html
      end
    end

  end

  def follow
    @user = User.find_by(uuid: current_user.uuid)
    @followings = @user.followings.page(params[:page]).per(20)
  end

  def follower
    @user = User.find_by(uuid: current_user.uuid)
    @followers = @user.followers.page(params[:page]).per(20)
  end

  private
    def set_user
      @user = User.find_by(uuid: params[:user_id])
    end
end
