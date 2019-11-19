class HomeController < ApplicationController
  def index
    @trends = Entry.trend(from_date: from_date).take(15)
    @entries = Entry.all.new_order.limit(15)
    @tags = Entry.tag_ranking.take(10)
  end

  :private
    def from_date
      period = params[:period]
      case period
      when "day"
        1.day.ago
      when "week"
        7.day.ago
      when "month"
        30.day.ago
      else
        1.day.ago
      end
    end
end
