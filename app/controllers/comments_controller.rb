class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @comment = current_user.comments.new(comment_params)
    @comment.article_token = params[:article_token]
    if @comment.save
      redirect_to public_path(params[:article_token]), notice: "コメントを投稿しました。"
    else
      flash[:alert] = "コメントするにはログインが必要です。"
    end
  end

  def update
    @comment = Comment.find_by(id: params[:id])
    @comment.content = params[:comment][:content]
    if @comment.save
      redirect_to public_path(@comment.article_token), notice: "コメントを更新しました。"
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
