class CommentsController < ApplicationController
  before_action :authenticate_user!
  def create
    @comment = current_user.comments.new(comment_params)
    @post = Post.find_by(id: params[:post_id])
    if @comment.save
      @comment = Comment.new
      respond_to do |format|
        format.js
        format.html
      end
    else
      redirect_to users_path
    end
  end

  def destroy
    @comment = Comment.find_by(id: params[:id])
    @post = @comment.post
    respond_to do |format|
      if @comment.destroy
        format.js
        format.html
      end
    end
  end

  private
  def comment_params
    params[:comment][:post_id] = params[:post_id]
    params.require(:comment).permit(:post_id, :content)
  end
end
