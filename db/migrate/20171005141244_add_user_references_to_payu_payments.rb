class AddUserReferencesToPayuPayments < ActiveRecord::Migration[6.1]
  def change
    add_reference :easy_pay_u_latam_payu_payments, :user, foreign_key: true
  end
end
