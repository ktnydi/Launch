module AccessAnalysisHelper

  # period can select "day", "week", "month"
  def access_count(period_range = "")
    article_tokens = current_user.publics.pluck(:article_token)

    period = case period_range
             when "day"
               Time.zone.now.beginning_of_day
             when "week"
               Time.zone.now.beginning_of_week
             when "month"
               Time.zone.now.beginning_of_month
             else
               ""
             end

    access_analyses = AccessAnalysis.where(article_token: article_tokens)
                                    .where("created_at > ?", period)
                                    .group(:article_token)
                                    .order("count_article_token DESC")
                                    .count(:article_token)

    access_count = access_analyses.values.inject do |sum, value|
      sum + value
    end
    
    access_count || 0
  end
end
