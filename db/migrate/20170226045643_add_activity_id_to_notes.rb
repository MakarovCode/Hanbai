class AddActivityIdToNotes < ActiveRecord::Migration[6.1]
  def change
    add_reference :notes, :activity, foreign_key: true
  end
end
