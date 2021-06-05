class ActivityType < ApplicationRecord
	has_many :activities
	belongs_to :user
	
	validates :name, :icon, :user_id, presence: true
end
