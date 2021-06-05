class PersonEmail < ApplicationRecord
	belongs_to :person

	validates :email, :kind, presence: true
end
