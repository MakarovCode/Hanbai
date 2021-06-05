class AddEstimatedCloseDateToDeals < ActiveRecord::Migration[6.1]
  def change
    add_column :deals, :estimated_close_date, :date
  end
end
