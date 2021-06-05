class Funnel < ApplicationRecord
	belongs_to :user

	has_many :stages
	has_many :extra_fields

	has_many :user_funnels
	has_many :users, through: :user_funnels

	has_many :history_logs

	validates :name, :user_id, presence: true

	PERMISSION_OWNER = "owner"
	PERMISSION_READ_ALL = "read_all"
	PERMISSION_WRITE_ALL = "write_all"
	PERMISSION_READ_OWN = "read_own"
	PERMISSION_WRITE_OWN = "write_own"

	def self.actives
		where status: [nil, 0]
	end

	def self.inactives
		where status: 1
	end

	def self.has_permission(permissions)
		includes(:user_funnels).where({user_funnels: {permission: permissions}}).references(:user_funnels)
	end
end
