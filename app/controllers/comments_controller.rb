class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      redirect_to post_path(params[:post_id])
    else
      @post = Post.find_by(id: params[:post_id])
      @likes_count = @post.likes.count
      render "posts/show"
    end
  end

  def destroy
    @comment = Comment.find_by(id: params[:id])
    post_id = @comment.post_id
    @comment.destroy
    redirect_to post_path(post_id)
  end

  private
  def comment_params
    params[:comment][:user_id] = current_user.id
    params[:comment][:post_id] = params[:post_id]
    params.require(:comment).permit(:user_id, :post_id, :content)
  end
end
