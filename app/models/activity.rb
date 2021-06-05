class Activity < ApplicationRecord
	belongs_to :activity_type
	belongs_to :user
	belongs_to :creator_user, class_name: "User", foreign_key: "creator_user_id"
	belongs_to :deal
	belongs_to :person

	has_many :notes

	has_many :history_logs

	accepts_nested_attributes_for :notes

	validates :title, :date_and_time, :activity_type_id, presence: true

	# before_save :transform_user_time_zone
	#
	# def transform_user_time_zone
	# 	self.date_and_time = "#{self.date_and_time }"
	# end

	def update_counts
		person = self.person
		unless person.nil?
			activities = person.activities
			person.activities_count = activities.actives.count
			person.done_activities_count = activities.done.count
			person.undone_activities_count = activities.by_statuses([nil, 0, 1]).count
			person.save

			company = person.company
			unless company.nil?
				activities = Activity.by_company(company)
				company.activities_count = activities.actives.count
				company.done_activities_count = activities.done.count
				company.undone_activities_count = activities.by_statuses([nil, 0, 1]).count
				company.save
			end
		end
		deal = self.deal
		unless deal.nil?
			activities = deal.activities
			deal.activities_count = activities.actives.count
			deal.done_activities_count = activities.done.count
			deal.undone_activities_count = activities.by_statuses([nil, 0, 1]).count
			deal.save
		end
	end

	def self.by_company(company)
		includes(:person).where({people: {company_id: company.id}}).references(:person)
	end

	def self.actives
		where status: [nil, 0, 1, 2]
	end

	def self.pending
		where status: [nil, 0]
	end

	def self.overdue
		where status: 1
	end

	def self.done
		where status: 2
	end

	def self.archived
		where status: 3
	end

	def get_status_name
		if self.status == 0
			"Pendiente"
		elsif self.status == 1
			"Retrazada"
		elsif self.status == 2
			"Completada"
		elsif self.status == 3
			"Archivada"
		else
			"Pendiente"
		end
	end

	def update_actual_status_time
		if status == 2
			update_attribute :done_time, Time.now
		end
	end

	def self.by_statuses(statuses)
		where status: statuses
	end

	def self.in_range(_start, _end)
		where(date_and_time: _start.._end)
	end

	def self.by_term(term)
		includes(:person).where("lower(unaccent(people.name)) iLIKE('%#{I18n.transliterate(term.downcase)}%') OR lower(unaccent(activities.title)) iLIKE('%#{I18n.transliterate(term.downcase)}%')").references(:person)
	end

	def self.in_date_range(start, _end)
		where(date_and_time: start.._end)
	end

	def self.daily(moment)
		User.to_send_daily_remember.with_moment_to_be_remember(moment).each do |user|
			@activities = user.activities.by_statuses([nil, 0, 1]).in_date_range(Date.today.at_beginning_of_day, Date.today.at_end_of_day)

			MainMailer.daily(user.id, @activities.pluck(:id)).deliver_now! if @activities.count > 0
		end
	end

	def self.just_before_activity
		User.to_send_just_before_activity_remember.each do |user|
			activities = user.activities.by_statuses([nil, 0, 1]).in_date_range(Time.current, Time.current + 15.minutes)

			activities.each do |activity|
				MainMailer.just_before_activity(user.id, activity.id).deliver_now!
			end
		end
	end

	def self.check_overdue
		Activity.pending.in_date_range(Time.current - 15.minutes, Time.current).update_all status: 1
	end

end
