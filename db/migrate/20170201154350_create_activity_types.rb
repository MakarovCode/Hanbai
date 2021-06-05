class CreateActivityTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :activity_types do |t|
      t.string :icon
      t.string :name
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
