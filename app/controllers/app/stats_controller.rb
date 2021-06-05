##
# Esta clase representa el usuario de la aplicación.

class App::StatsController < App::AppController

	def index

		@funnels = current_user.funnels_as_member.actives


		unless params[:start_date].nil?
			begin
				@start_date = params[:start_date].to_date
			rescue
				@start_date = Time.now.at_beginning_of_month
			end
		else
			@start_date = Time.now.at_beginning_of_month
		end

		unless params[:end_date].nil?
			begin
				@end_date = params[:end_date].to_date
			rescue
				@end_date = Time.now.at_end_of_month
			end
		else
			@end_date = Time.now.at_end_of_month
		end

		if (params[:start_date].nil? || params[:start_date] == "") && (params[:end_date].nil? || params[:end_date] == "")
			unless params[:period].nil?
				if params[:period] == "month"
					@start_date = Time.now.at_beginning_of_month
					@end_date = Time.now.at_end_of_month
				elsif params[:period] == "last_month"
					@start_date = Time.now.at_beginning_of_month - 1.month
					@end_date = @start_date.at_end_of_month
				elsif params[:period] == "week"
					@start_date = Time.now.at_beginning_of_week
					@end_date = Time.now.at_end_of_week
				elsif params[:period] == "last_week"
					@start_date = Time.now.at_beginning_of_week
					@end_date = @start_date.at_end_of_week
				elsif params[:period] == "year"
					@start_date = Time.now.at_beginning_of_year
					@end_date = Time.now.at_end_of_year
				elsif params[:period] == "last_year"
					@start_date = Time.now.at_beginning_of_year
					@end_date = @start_date.at_end_of_year
				end
			end
		end

		diff_days = (@end_date - @start_date).to_i / 1.days

		@old_start_date = @start_date - diff_days.days
		@old_end_date = @end_date - diff_days.days

		@deals = current_user.deals.by_statuses([nil, 0, 1, 2])

		if !params[:funnel_id].nil? && params[:funnel_id] != ""
			@funnel = @funnels.find params[:funnel_id]
			@new_deals = @deals.by_funnels(@funnel.id).by_statuses([nil, 0, 1, 2]).where(created_at: @start_date..@end_date)
			@won_deals = @deals.by_funnels(@funnel.id).won.where(won_time: @start_date..@end_date)
			@lost_deals = @deals.by_funnels(@funnel.id).lost.where(lost_time: @start_date..@end_date)

			@old_new_deals = @deals.by_funnels(@funnel.id).by_statuses([nil, 0, 1, 2]).where(created_at: @old_start_date..@old_end_date)
			@old_won_deals = @deals.by_funnels(@funnel.id).won.where(won_time: @old_start_date..@old_end_date)
			@old_lost_deals = @deals.by_funnels(@funnel.id).lost.where(lost_time: @old_start_date..@old_end_date)
		else
			@new_deals = @deals.by_statuses([nil, 0, 1, 2]).where(created_at: @start_date..@end_date)
			@won_deals = @deals.won.where(won_time: @start_date..@end_date)
			@lost_deals = @deals.lost.where(lost_time: @start_date..@end_date)

			@old_new_deals = @deals.by_statuses([nil, 0, 1, 2]).where(created_at: @old_start_date..@old_end_date)
			@old_won_deals = @deals.won.where(won_time: @old_start_date..@old_end_date)
			@old_lost_deals = @deals.lost.where(lost_time: @old_start_date..@old_end_date)
		end

		@new_business = {count: @new_deals.count, amount: @new_deals.sum(:total), commission: @new_deals.sum(:commission), count_difference: @new_deals.count - @old_new_deals.count, amount_difference: @new_deals.sum(:total) - @old_new_deals.sum(:total), commission_difference: @new_deals.sum(:commission) - @old_new_deals.sum(:commission)}

		@won_business = {count: @won_deals.count, amount: @won_deals.sum(:total), commission: @won_deals.sum(:commission), count_difference: @won_deals.count - @old_won_deals.count, amount_difference: @won_deals.sum(:total) - @old_won_deals.sum(:total), commission_difference: @won_deals.sum(:commission) - @old_won_deals.sum(:commission)}

		@lost_business = {count: @lost_deals.count, amount: @lost_deals.sum(:total), commission: @lost_deals.sum(:commission), count_difference: @lost_deals.count - @old_lost_deals.count, amount_difference: @lost_deals.sum(:total) - @old_lost_deals.sum(:total), commission_difference: @lost_deals.sum(:commission) - @old_lost_deals.sum(:commission)}

		@activities = current_user.activities.actives.in_range(@start_date, @end_date)

		@activity_types = current_user.activity_types.includes(:activities).where({activities: {status: [nil, 0, 1, 2]}}).references(:activities)

		@new_activities = []
		@done_activities = []

		@new_max = 0
		@done_max = 0

		@activity_types.each do |type|
			activities = type.activities.actives.in_range(@start_date, @end_date)
			old_activities = type.activities.actives.in_range(@old_start_date, @old_end_date)

			if activities.count > 0# || old_activities.count > 0
				@new_max = activities.count if @new_max < activities.count
				@new_activities.push({icon: type.icon, name: type.name, count: activities.count, count_difference: activities.count - old_activities.count})
			end

			done_activities = type.activities.done.where(done_time: @start_date..@end_date)
			done_old_activities = type.activities.done.where(done_time: @old_start_date..@old_end_date)

			if done_activities.done.count > 0# || done_old_activities.count > 0
				@done_max = done_activities.count if @done_max < done_activities.count
				@done_activities.push({icon: type.icon, name: type.name, count: done_activities.count, count_difference: done_activities.count - done_activities.count})
			end
		end

		@new_max = 1 if @new_max == 0
		@done_max = 1 if @done_max == 0

	end

end
