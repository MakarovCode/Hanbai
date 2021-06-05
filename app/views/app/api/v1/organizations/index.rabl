object @companies

attributes :id, :name, :address, :people_count, :open_deals_count, :won_deals_count, :closed_deal_count, :activities_count, :done_activities_count, :undone_activities_count

node :created_at do |company|
	l company.created_at, format: "%B de %Y"
end

node :notes, if: lambda { |s| @full_data == true } do |company|
	company.notes.map { |n| { node: partial("app/api/v1/notes/index", object: n) }  }
end

child :people do
	attributes :id, :company_id, :name, :role, :open_deals_count, :won_deals_count, :closed_deal_count, :activities_count, :done_activities_count, :undone_activities_count

	child person_phones: :phones do
		attributes :id, :phone
	end

	child person_emails: :emails do
		attributes :id, :email
	end
end
