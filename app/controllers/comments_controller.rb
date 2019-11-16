class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @comment = current_user.comments.new(comment_params)
    @comment.entry_token = params[:token]
    if @comment.save
      redirect_to entry_path(params[:token])
    else
      flash[:alert] = "コメントするにはログインが必要です。"
    end
  end

  def destroy
    @entry = Entry.find_by(token: params[:token])
    @comment = current_user.comments.find_by(id: params[:id], entry_token: params[:token])
    if @comment.destroy
      redirect_to entry_path(@entry)
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:content)
  end
end
