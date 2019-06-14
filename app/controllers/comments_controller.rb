class CommentsController < ApplicationController
  before_action :authenticate_user!
  def create
    @comment = current_user.comments.new(comment_params)
    @post = Post.find_by(uuid: params[:post_id])
    if @comment.save
      respond_to do |format|
        @comment = Comment.new
        format.js
      end
    else
      redirect_to post_path(@post)
    end
  end

  def destroy
    @comment = Comment.find_by(id: params[:id])
    @post = @comment.post
    if @comment.destroy
      redirect_to post_path(@post)
    end
  end

  private
  def comment_params
    params[:comment][:post_id] = params[:post_id]
    params.require(:comment).permit(:post_id, :content)
  end
end
