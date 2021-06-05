class CreateSetups < ActiveRecord::Migration[6.1]
  def change
    create_table :setups do |t|
      t.references :user, foreign_key: true
      t.boolean :remember_me_notifications, default: true
      t.boolean :moment_to_be_remember, default: true
      t.string :token_api
      t.integer :status

      t.timestamps
    end
  end
end
