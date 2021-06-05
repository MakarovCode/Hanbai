class Stage < ApplicationRecord
	belongs_to :funnel
	
	has_many :deals
	
	validates :name, :funnel_id, presence: true
	
	def self.actives 
		where status: [nil, 0]
	end
	
	def self.inactives 
		where status: 1
	end
	
	def self.as_funnel_member(user_id)
		includes({funnel: :user_funnels}).where("user_funnels.user_id = ?", user_id).references({funnel: :user_funnels})
	end
end
