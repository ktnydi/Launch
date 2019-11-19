module Search
  extend ActiveSupport::Concern

  included do
    scope :search, -> (query) do
      rel = order(created_at: :desc)
      if query.present?
        rel = rel.where("title LIKE ? OR tags LIKE ?", "%#{query}%", "%#{query}%")
      end
      rel
    end
    
  end
end
