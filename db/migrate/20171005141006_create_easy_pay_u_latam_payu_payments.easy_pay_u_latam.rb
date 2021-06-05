# This migration comes from easy_pay_u_latam (originally 20170929211207)
class CreateEasyPayULatamPayuPayments < ActiveRecord::Migration[6.1]
  def change
    create_table :easy_pay_u_latam_payu_payments do |t|
      t.integer :status
      t.date :start_date
      t.date :end_date
      t.string :period
      t.string :reference_code
      t.string :description
      t.float :amount
      t.float :tax
      t.float :tax_return_base
      t.string :currency
      t.string :buyer_full_name
      t.string :buyer_email
      t.string :shipping_address
      t.string :shipping_city
      t.string :shipping_country
      t.string :buyer_phone
      t.integer :transaction_state
      t.float :risk
      t.string :reference_pol
      t.integer :installments_units
      t.datetime :processing_date
      t.string :cus
      t.string :pse_bank
      t.string :response_code
      t.string :payment_method
      t.string :payment_method_type
      t.string :payment_method_name
      t.string :payment_request_state
      t.string :franchise
      t.string :lap_transaction_state
      t.string :message
      t.string :authorization_code
      t.string :transaction_id
      t.string :trazability_code
      t.string :state_pol
      t.string :number_card
      t.string :payer_name
      t.string :billing_country
      t.string :response_message_pol
      t.string :sign
      t.string :billing_address
      t.string :billing_city
      t.string :buyer_nickname
      t.string :bank_id
      t.string :customer_number
      t.float :administrative_fee_base
      t.integer :attempts
      t.string :merchant_id
      t.string :exchange_rate
      t.string :ip

      t.timestamps
    end
  end
end
