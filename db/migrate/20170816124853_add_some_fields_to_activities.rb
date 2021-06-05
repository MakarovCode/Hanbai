class AddSomeFieldsToActivities < ActiveRecord::Migration[6.1]
  def change
    add_column :activities, :done_time, :datetime
  end
end
