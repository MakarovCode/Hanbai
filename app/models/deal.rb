class Deal < ApplicationRecord
	belongs_to :creator_user, class_name: "User", foreign_key: "creator_user_id"
	belongs_to :user
	belongs_to :stage
	belongs_to :person

	has_many :attachments
	has_many :activities

	has_many :history_logs

	has_many :user_deals
	has_many :users, through: :user_deals

	has_many :extra_field_deals
  has_many :extra_fields, through: :extra_field_deals

	accepts_nested_attributes_for :extra_field_deals

	validates :title, :creator_user_id, :user_id, :total, :commission, :stage_id, :estimated_close_date, :currency, presence: true

	def update_counts
		person = self.person
		unless person.nil?
			deals = person.deals
			person.open_deals_count = deals.actives.count
			person.won_deals_count = deals.won.count
			person.closed_deal_count = deals.by_statuses([1,2]).count
			person.save

			company = person.company
			unless company.nil?
				deals = Deal.by_company(company)
				company.open_deals_count = deals.actives.count
				company.won_deals_count = deals.won.count
				company.closed_deal_count = deals.by_statuses([1,2]).count
				company.save
			end
		end
	end

	def self.by_company(company)
		includes(:person).where({people: {company_id: company.id}}).references(:person)
	end

	def self.by_statuses(statues)
		where status: statues
	end

	def self.actives
		where status: [nil, 0]
	end

	def self.won
		where status: 1
	end

	def self.lost
		where status: 2
	end

	def self.archived
		where status: 3
	end

	def get_status_name
		if self.status == 0
			"Activo"
		elsif self.status == 1
			"Ganado"
		elsif self.status == 2
			"Perdido"
		elsif self.status == 3
			"Archivada"
		else
			"Activo"
		end
	end

	def update_actual_status_time
		if status == 1
			update_attribute :won_time, Time.now
		elsif status == 2
			update_attribute :lost_time, Time.now
		elsif status == 3
			update_attribute :close_time, Time.now
		end
	end

	def self.by_term(term)
		where("lower(unaccent(title)) iLIKE('%#{I18n.transliterate(term.downcase)}%')")
	end

	def self.by_funnels(funnel_id)
		includes(:stage).where({stages: {funnel_id: funnel_id}}).references(:stage)
	end


end
