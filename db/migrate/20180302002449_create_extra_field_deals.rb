class CreateExtraFieldDeals < ActiveRecord::Migration[6.1]
  def change
    create_table :extra_field_deals do |t|
      t.references :extra_field, foreign_key: true
      t.references :deal, foreign_key: true
      t.string :value
      t.integer :kind
      t.integer :status

      t.timestamps
    end
  end
end
