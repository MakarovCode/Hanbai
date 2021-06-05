class CreateActivities < ActiveRecord::Migration[6.1]
  def change
    create_table :activities do |t|
      t.string :title
      t.references :activity_type, foreign_key: true
      t.datetime :date_and_time
      t.integer :duration
      t.text :notes
      t.references :user, foreign_key: true
      t.references :creator_user, foreign_key: { to_table: :users }
      t.references :deal, foreign_key: true
      t.references :person, foreign_key: true
      t.integer :status

      t.timestamps
    end
  end
end
