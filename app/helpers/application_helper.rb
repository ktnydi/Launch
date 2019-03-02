module ApplicationHelper
  def page_title
    if @page_title
      title = "#{@page_title} | Launch"
    else
      title = "Launch"
    end
    title
  end
end
