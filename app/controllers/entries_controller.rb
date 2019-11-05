class EntriesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  
  def index
    @entries = Entry.publics.search(params[:query]).new_order.page(params[:page]).per(30)
  end

  def show
    @entry = Entry.find_by(token: params[:token])
  end

  def new
    @entry = Entry.new
    render layout: "editor"
  end

  def create
    @entry = current_user.entries.new(entry_params)
    if @entry.save
      redirect_to dashboard_path, notice: "記事を作成しました。"
    else
      @messages = @entry.errors.full_messages
      render new_entry_path, layout: "editor"
    end
  end

  def edit
    @entry = Entry.find_by(token: params[:token])
    @entry.tags = @entry.tags.join(",")
    render layout: "editor"
  end

  def update
    @entry = Entry.find_by(token: params[:token])
    if @entry.update_attributes(entry_params)
      redirect_to dashboard_path, notice: "記事を更新しました。"
    else
      @messages = @entry.errors.full_messages
      render 'edit', layout: "editor"
    end
  end

  def destroy
    @entry = Entry.find_by(token: params[:token])
    if @entry.destroy
      redirect_to dashboard_path, notice: "記事を削除しました。"
    end
  end

  :private
    def entry_params
      params.require(:entry).permit(:status, :title, :tags, :content)
    end
end
