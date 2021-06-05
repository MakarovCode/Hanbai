object @stages

attributes :id, :name, :is_standing, :priority

node :deals, if: lambda { |s| @full_data == true } do |stage|
	stage.deals.actives.order("priority ASC").map { |d| partial("app/api/v1/deals/index", object: d)  }
end

node :activities_percent do |stage|
	deals = stage.deals.actives
	activities_count = 0
	done_activities_count = 0
	deals.each do |deal|
		done_activities_count += deal.done_activities_count
		activities_count += deal.activities_count
	end
	unless activities_count == 0
		(done_activities_count * 100)/activities_count
	else
		100
	end
end
