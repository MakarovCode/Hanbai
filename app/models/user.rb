class User < ApplicationRecord

	acts_as_token_authenticatable

	devise :database_authenticatable, :registerable,
	:recoverable, :rememberable, :trackable, :validatable,
	:lockable#, :confirmable


	has_many :history_logs
	has_many :extra_fields
	has_many :deals
	has_many :user_deals
	has_many :deals_as_creator, class_name: "Deal", foreign_key: "creator_user_id"

	has_many :activities
	has_many :activities_as_creator, class_name: "Activity", foreign_key: "creator_user_id"

	has_many :user_funnels
	has_many :funnels_as_member, through: :user_funnels, source: :funnel

	has_many :funnels

	has_many :payments
	has_many :activity_types
	has_many :companies
	has_many :people
	has_many :notes

	has_one :setup

	accepts_nested_attributes_for :setup

	mount_uploader :image, AttachmentUploader

	validates :name, presence: true
	validates :image, file_size: { less_than: 2.megabytes }

	after_create :generate_credentials

	DEMO = nil
	ACTIVE = 1
	PENDING_PAYMENT = 2
	INACTIVE = 3

	def generate_credentials
		self.uuid = "#{Devise.friendly_token(40)}#{self.id}"
		self.ensure_authentication_token
		self.save
		self.activity_types.create([{name: "Llamada", icon: "fa fa-phone"}, {name: "Reunión", icon: "fa fa-users"}, {name: "Tarea", icon: "fa fa-tumb-tack"}, {name: "Plazo", icon: "fa fa-flag"}, {name: "Correo", icon: "fa fa-envelope"}, {name: "Café/Comida", icon: "fa fa-coffee"}])
		Setup.create user_id: self.id
	end

	def self.with_moment_to_be_remember(moment)
		includes(:setup).where({setups: {moment_to_be_remember: moment}}).references(:setup)
	end

	def self.demo
		where status: [nil, 0]
	end

	def self.silver
		where status: 1
	end

	def self.gold
		where status: 2
	end

	def self.gold_pending
		where status: 3
	end

	def self.to_send_daily_remember
		where status: [nil, 0, 1, 2, 3]
	end

	def self.to_send_just_before_activity_remember
		where status: [nil, 0, 2, 3]
	end

	def is_gold
		payment = EasyPayULatam::PayuPayment.where(user_id: self.id, status: 1).order(created_at: :desc).first
		unless payment.nil?
			if payment.start_date.to_date <= Date.today && payment.end_date.to_date >= Date.today
				true
			else
				false
			end
		else
			false
		end
	end

	def is_gold_expiring
		payment = EasyPayULatam::PayuPayment.where(user_id: self.id, status: 1).order(created_at: :desc).first
		unless payment.nil?
			if payment.end_date.to_date - 5.days <= Date.today.at_beginning_of_day && payment.end_date.to_date >= Date.today.at_end_of_day
				true
			else
				false
			end
		else
			false
		end
	end

	def last_payment
		payment = EasyPayULatam::PayuPayment.where(user_id: self.id, status: 1).order(created_at: :desc).first
	end

	def self.accounts_expiring(days_left)
		date = Date.today + days_left.days
		payments = EasyPayULatam::PayuPayment.where(status: 1, end_date: date.at_beginning_of_day..date.at_end_of_day)

		payments.each do |payment|
			MainMailer.accounts_expiring(payment.user, payment.end_date)
		end

	end

	def self.accounts_expired
		date = Date.today
		payments = EasyPayULatam::PayuPayment.where(status: 1, end_date: date.at_beginning_of_day..date.at_end_of_day)

		payments.each do |payment|
			MainMailer.accounts_expired(payment.user)
		end
	end

	def self.by_term(term)
		where("name ILIKE '%#{term}%' OR email ILIKE '%#{term}%'")
	end

	def is_funnel_member(funnel)
		self.user_funnels.where(funnel_id: funnel.id).count > 0
	end

	def is_deal_member(deal)
		self.user_deals.where(deal_id: deal.id).count > 0
	end

	def get_funnel_member_permissions(funnel)
		user_funnel = self.user_funnels.where(funnel_id: funnel.id).first
		unless user_funnel.nil?
			{name: user_funnel.permission, permission: user_funnel.permission}
		else
			{name: "Normal", permission: "normal"}
		end
	end

end
