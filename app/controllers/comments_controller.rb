class CommentsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @comment = current_user && current_user.comments.new(comment_params)
    @comment.article_token = params[:article_token]
    @public = Public.find_by(article_token: params[:article_token])
    respond_to do |format|
      if @comment&.save
        @comment = Comment.new
        format.js
      else
        flash[:alert] = "コメントするにはログインが必要です。"
        format.js { render js: "window.location = '#{new_user_session_path}';" }
      end
    end
  end

  def update
    @comment = Comment.find_by(id: params[:id])
    @comment.content = params[:comment][:content]
    if @comment.save
      redirect_to public_path(@comment.article_token)
    end
  end

  def destroy
    @comment = Comment.find_by(id: params[:id])
    @public = @comment.public
    if @comment.destroy
      redirect_to public_path(@public)
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:content)
  end
end
