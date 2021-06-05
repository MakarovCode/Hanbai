class CreateUserDeals < ActiveRecord::Migration[6.1]
  def change
    create_table :user_deals do |t|
      t.references :user, foreign_key: true
      t.references :deal, foreign_key: true
      t.string :permission

      t.timestamps
    end
  end
end
