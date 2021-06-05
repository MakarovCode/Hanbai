object @activities

attributes :id, :title, :duration, :status, :person_id, :deal_id, :user_id, :activity_type_id

child :activity_type do
	attributes :id, :name, :icon
end

child :user do
	attributes :id, :name, :email
end

child :creator_user do
	attributes :id, :name, :email
end

node :deal_title do |activity|
	unless activity.deal.nil?
		activity.deal.title
	else
		""
	end
end

child :deal do
	attributes :id, :title

	child :stage do
		attributes :id, :name

		child :funnel do
			attributes :id, :name
		end
	end
end

node :person_name do |activity|
	unless activity.person.nil?
		activity.person.name
	else
		""
	end
end

child :person do
	attributes :id, :name, :notes

	child person_phones: :phones do
		attributes :id, :phone, :kind
	end

	child person_emails: :emails do
		attributes :id, :email, :kind
	end

	child person_addresses: :addresses do
		attributes :id, :address, :kind
	end

	child :company do
		attributes :id, :name, :notes
	end
end

child :notes do
	attributes :text
end

node :editable do |deal|
	true
end

node :start do |deal|
	unless deal.date_and_time.nil?
		deal.date_and_time.strftime("%Y-%m-%d %H:%M:00")
	else
		"0000-00-00"
	end
end

node :end do |deal|
	unless deal.date_and_time.nil?
		(deal.date_and_time + deal.duration.minutes).strftime("%Y-%m-%d %H:%M:00")
	else
		"0000-00-00"
	end
end

node :date_and_time do |deal|
	unless deal.date_and_time.nil?
		deal.date_and_time.strftime("%Y-%m-%d %H:%M:00")
	else
		"Sin información"
	end
end

node :date do |deal|
	unless deal.date_and_time.nil?
		deal.date_and_time.strftime("%Y-%m-%d")
	else
		"Sin información"
	end
end

node :time do |deal|
	unless deal.date_and_time.nil?
		deal.date_and_time.strftime("%I:%M %p")
	else
		"Sin información"
	end
end

node :time_iso do |deal|
	unless deal.date_and_time.nil?
		deal.date_and_time.strftime("%H:%M")
	else
		"Sin información"
	end
end

node :status_name do |activity|
	if activity.status == 0 || activity.status.nil?
		"Pendiente"
	elsif activity.status == 1
		"Vencida"
	else
		"Realizada"
	end
end

node :color do |activity|
	if activity.status == 0 || activity.status.nil?
		"#3498DB"
	elsif activity.status == 1
		"#EC7063"
	else
		"#58D68D"
	end
end
