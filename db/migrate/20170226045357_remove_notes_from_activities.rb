class RemoveNotesFromActivities < ActiveRecord::Migration[6.1]
  def change
    remove_column :activities, :notes
  end
end
