class CreateCoupons < ActiveRecord::Migration[6.1]
	def change
		create_table :coupons do |t|
			t.string :token
			t.date :expiration_date
			t.string :kind
			t.float :value
			t.integer :status

			t.timestamps
		end
	end
end
