class CommentsController < ApplicationController
  def create
    @comment = current_user && current_user.comments.new(comment_params)
    @post = Post.find_by(uuid: params[:post_id])
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
      redirect_to post_path(@comment.post_id)
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
