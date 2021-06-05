class Coupon < ApplicationRecord
	has_one :payment
	
	validates :token, :expiration_date, :kind, :value, presence: true
end
