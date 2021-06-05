class PersonPhone < ApplicationRecord
	belongs_to :person

	validates :phone, :kind, presence: true
end
