class Payment < ApplicationRecord
	belongs_to :user
	belongs_to :coupon

	validates :user_id, :period, :subtotal, :iva, :total, presence: true
end
