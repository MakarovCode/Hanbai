object @funnels

attributes :id, :name, :color, :priority

node :pending_deals_percent, if: lambda { |s| @stats == true } do |funnel|
	if @deals.by_statuses([nil, 0, 1, 2]).count > 0
		@deals.actives.count * 100 / @deals.by_statuses([nil, 0, 1, 2]).count
	else
		0
	end
end

node :pending_deals_count, if: lambda { |s| @stats == true } do |funnel|
	@deals.actives.count
end

node :pending_deals_sum, if: lambda { |s| @stats == true } do |funnel|
	@deals.actives.sum(:total)
end

node :won_deals_percent, if: lambda { |s| @stats == true } do |funnel|
	if @deals.by_statuses([nil, 0, 1, 2]).count > 0
		@deals.won.count * 100 / @deals.by_statuses([nil, 0, 1, 2]).count
	else
		0
	end
end

node :won_deals_count, if: lambda { |s| @stats == true } do |funnel|
	@deals.won.count
end

node :won_deals_sum, if: lambda { |s| @stats == true } do |funnel|
	@deals.won.sum(:total)
end

node :lost_deals_percent, if: lambda { |s| @stats == true } do |funnel|
	if @deals.by_statuses([nil, 0, 1, 2]).count > 0
		@deals.lost.count * 100 / @deals.by_statuses([nil, 0, 1, 2]).count
	else
		0
	end
end

node :lost_deals_count, if: lambda { |s| @stats == true } do |funnel|
	@deals.lost.count
end

node :lost_deals_sum, if: lambda { |s| @stats == true } do |funnel|
	@deals.lost.sum(:total)
end

child :stages do

	attributes :id, :name, :is_standing, :priority

	node :deals, if: lambda { |s| @full_data == true } do |stage|
		stage.deals.map { |d| partial("app/api/v1/deals/index", object: d)  }
	end

end

node :members do |funnel|
	funnel.users.map { |d| partial("app/api/v1/users/index", object: d) }
end
