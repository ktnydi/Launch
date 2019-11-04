class EntriesController < ApplicationController
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
    
  end

  def destroy
    
  end

  :private
    def entry_params
      params.require(:entry).permit(:status, :title, :tags, :content)
    end
end
