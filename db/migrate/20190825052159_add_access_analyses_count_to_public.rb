class AddAccessAnalysesCountToPublic < ActiveRecord::Migration[5.2]
  def change
    add_column :publics, :access_analyses_count, :integer, null: false, default: 0
  end
end
