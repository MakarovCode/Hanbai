object @people

attributes :id, :company_id, :name, :role, :open_deals_count, :won_deals_count, :closed_deal_count, :activities_count, :done_activities_count, :undone_activities_count, :status

node :created_at do |person|
	l person.created_at, format: "%B de %Y"
end

child :company do
	attributes :id, :name
end

child :attachments, if: lambda { |s| @full_data == true } do |person|
	attributes :id, :source
end

node :phones_as_text do |person|
	text = ""
	person.person_phones.each_with_index do |phone, index|
		if index > 0
			text += " - "
		end
		text += "#{phone.phone}"
	end
	text
end

node :emails_as_text do |person|
	text = ""
	person.person_emails.each_with_index do |email, index|
		if index > 0
			text += " - "
		end
		text += "#{email.email}"
	end
	text
end

child person_phones: :phones do
	attributes :id, :phone, :kind
end

child person_emails: :emails do
	attributes :id, :email, :kind
end

child person_addresses: :addresses do
	attributes :id, :address, :kind
end

node :last_activity do |person|
	partial("app/api/v1/activities/index", object: person.activities.last)
end

node :activities, if: lambda { |s| @full_data == true } do |person|
	person.activities.map { |a| partial("app/api/v1/activities/index", object: a) }
end

node :deals, if: lambda { |s| @full_data == true } do |person|
	person.deals.map { |d| partial("app/api/v1/deals/index", object: d) }
end

node :notes, if: lambda { |s| @full_data == true } do |person|
	person.notes.map { |n| partial("app/api/v1/notes/index", object: n) }
end

child :extra_field_contacts do
	attributes :id, :value, :kind

	node :extra_field do |efd|
		partial("app/api/v1/extra_fields/index", object: efd.extra_field)
	end
end
