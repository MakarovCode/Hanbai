class CreatePayments < ActiveRecord::Migration[6.1]
  def change
    create_table :payments do |t|
      t.references :user, foreign_key: true
      t.string :period
      t.datetime :pay_time
      t.float :subtotal
      t.float :iva
      t.float :total
      t.float :discount
      t.references :coupon, foreign_key: true
      t.integer :status

      t.timestamps
    end
  end
end
