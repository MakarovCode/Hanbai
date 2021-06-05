object @deals

attributes :id, :title, :value, :tax, :total, :currency, :priority, :commission, :activities_count, :done_activities_count, :undone_activities_count, :lost_reason, :estimated_close_date, :status

node :last_activity do |deal|
	partial("app/api/v1/activities/index", object: deal.activities.actives.last)
end

node :activities, if: lambda { |s| @full_data == true } do |deal|
	deal.activities.actives.order("date_and_time ASC").map { |a| partial("app/api/v1/activities/index", object: a)   }
end

node :activities_status do |deal|
	deals = deal.activities.actives
	if deals.overdue.count > 0
		1
	elsif deals.pending.count > 0
		0
	else
		2
	end
end

node :activities_percent do |deal|
	if deal.activities_count > 0
		(deal.done_activities_count * 100)/deal.activities_count
	else
		0
	end
end

child :user do
	attributes :id, :name, :email
end

child :creator_user do
	attributes :id, :name, :email
end

child :stage do
	attributes :id, :name

	child :funnel do
		attributes :id, :name
	end
end

child :person do
	attributes :id, :name, :notes

	child person_phones: :phones do
		attributes :id, :phone
	end

	child person_emails: :emails do
		attributes :id, :email
	end

	child :company do
		attributes :id, :name, :notes
	end
end

node :person_name do |deal|
	unless deal.person.nil?
		deal.person.name
	else
		""
	end
end

child :attachments, if: lambda { |s| @full_data == true } do |person|
	attributes :id, :source
end

child :extra_field_deals do
	attributes :id, :value, :kind

	node :extra_field do |efd|
		partial("app/api/v1/extra_fields/index", object: efd.extra_field)
	end
end

node :stage_change_time do |deal|
	unless deal.stage_change_time.nil?
		l deal.stage_change_time, format: :short
	else
		"Sin información"
	end
end

node :won_time do |deal|
	unless deal.won_time.nil?
		l deal.won_time, format: :short
	else
		"Sin información"
	end
end

node :close_time do |deal|
	unless deal.close_time.nil?
		l deal.close_time, format: :short
	else
		"Sin información"
	end
end

node :members do |deal|
	deal.users.map { |d| partial("app/api/v1/users/index", object: d)  }
end
