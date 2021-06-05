class Note < ApplicationRecord
	belongs_to :company
	belongs_to :person
	belongs_to :user
	belongs_to :activity

	# validates :text, presence: true
	#validates :company_id, presence: true, if: :person_present?
	#validates :person_id, presence: true, if: :company_present?

	def person_present?
		person_id.nil?
	end

	def company_present?
		company_id.nil?
	end
end
