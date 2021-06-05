##
# Esta clase representa el usuario de la aplicación.

class App::FunnelsController < App::AppController
	def index

		if current_user.funnels_as_member.actives.count == 0
			funnel = current_user.funnels.new name: "Embudo Incalate", color: "#17202A"
			funnel.color = "#3498DB"
			if funnel.save validate: false
				funnel.stages.create([{name: "Contacto", priority: 1}, {name: "Contacto establecido", priority: 2}, {name: "Establecer necesidades", priority: 3}, {name: "Propuesta", priority: 4}])
				current_user.user_funnels.create(funnel_id: funnel.id, permission: Funnel::PERMISSION_OWNER)
				HistoryLog.create_for current_user, funnel, "Ha creado el embudo #{funnel.name}"
				funnel.stages.each do |stage|
					HistoryLog.create_for current_user, stage, "Ha creado la etapa #{stage.name} en el orden #{stage.priority}"
				end
			end
		else
			@funnel = current_user.funnels_as_member.find_by_id params[:funnel_id]
		end

		tmp_funnels = UserFunnel.where tmp_user_id: current_user.id
		if tmp_funnels.count > 0
			tmp_funnels.update_all tmp_user_id: nil, user_id: current_user.id
		end

		tmp_funnels.each do |user_funnel|
			HistoryLog.create_for current_user, user_funnel.funnel, "Ha aceptado su invitación para participar del embudo #{user_funnel.funnel.name}"
		end

		@activity = Activity.new

	end
end
