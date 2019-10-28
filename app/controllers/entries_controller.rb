class EntriesController < ApplicationController
  def index
    
  end

  def show
    
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
