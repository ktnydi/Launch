class PostsController < ApplicationController
  def index
    @posts = Post.all.order(created_at: :desc)
  end

  def show
  end

  def new
    @post = Post.new
    render :layout => "editor"
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      flash.notice = "記事を公開しました。"
      redirect_to :root
    else
    end
  end

  def edit
  end

  def update
  end

  def destroy
    @post = Post.find_by(id: params[:id])
    @post.destroy
    redirect_to :root
  end

  private
  def post_params
    params.require(:post).permit(:title, :content)
  end
end
