##
# Esta clase representa los negocios de un usuario.

class App::Api::V1::DealsController < App::Api::ApiController

	def autocomplete
		@deals = current_user.deals.actives.by_term params[:term]
	end

	##
	# Devuelve la lista de negocios del usuario en sesión
	#
	# <b>GET: /api/v1/deals.json</b>
	#
	# === Params:
	#   user_uuid - Usuario UUID
	#   user_token - Usuario Token de autenticación
	#
	# == Ejemplos
	#
	# === Status Ok
	#   => 200
	#
	# === Respuesta
	#   => [
	#		  {
	#			"name": "Pokemon Company",
	#			"address": "Tokio Avn 231",
	#			"notes": "They need a brand new Master Ball",
	#			"people_count": 0,
	#			"open_deals_count": 0,
	#			"won_deals_count": 0,
	#			"closed_deal_count": 0,
	#			"activities_count": 0,
	#			"done_activities_count": 0,
	#			"undone_activities_count": 0
	#		  }
	#	   ]
	#
	# === Status Sin autorización
	#   => 422
	#
	# === Respuesta
	#   => {"message": "Necesitas iniciar sesión o registrarte para continuar"}
	#

	def index
		@full_data = false
		if params[:status].nil?
			@deals = current_user.deals.actives
		else
			@deals = current_user.deals.by_statuses params[:status]
		end
	end


	##
	# Devuelve un negocio del usuario en sesión por un ID
	#
	# <b>GET: /api/v1/deals/<id>.json</b>
	#
	# === Params:
	#   user_uuid - Usuario UUID
	#   user_token - Usuario Token de autenticación
	#   full_data - Si true envía los Attachments (Archivos adjuntos) y Activities (actividades).
	#
	# == Ejemplos
	#
	# === Status Ok
	#   => 200
	#
	# === Respuesta
	#   => {
	#	  "name": "Pokemon Company",
	#	  "address": "Tokio Avn 231",
	#	  "notes": "They need a brand new Master Ball",
	#	  "people_count": 0,
	#	  "open_deals_count": 0,
	#	  "won_deals_count": 0,
	#	  "closed_deal_count": 0,
	#	  "activities_count": 0,
	#	  "done_activities_count": 0,
	#	  "undone_activities_count": 0
	#	}
	#
	# === Status Sin autorización
	#   => 422
	#
	# === Respuesta
	#   => {"message": "Necesitas iniciar sesión o registrarte para continuar"}
	#
	# === Status No encontrado
	#   => 404
	#
	# === Respuesta
	#   => {"message": "Recurso no encontrado"}
	#

	def show
		@full_data = params[:full_data] == "true"
		@deals = current_user.deals.find params[:id]
		render "index"
	end


	##
	# Crea un negocio sobre el usuario en sesión
	#
	# <b>POST: /api/v1/deals.json</b>
	#
	# === Params:
	#   user_uuid - Usuario UUID
	#   user_token - Usuario Token de autenticación
	#   deal - {title: "Brand new Master Balls", user_id: 101, value: 150000, tax: 10%, total: 165000, commission: 25%, currency: "COP", stage_id: 190, person_id: 151, priority: 1}
	#
	# == Ejemplos
	#
	# === Status Ok
	#   => 200
	#
	# === Respuesta
	#   => {"message": "Negocio creado correctamente", id: 1}
	#
	# === Status Sin autorización
	#   => 422
	#
	# === Respuesta
	#   => {"message": "Necesitas iniciar sesión o registrarte para continuar"}
	#
	# === Status No encontrado
	#   => 411
	#
	# === Respuesta
	#   => {"message": "No se pudo crear el negocio", errors: "Título no puede estar en blanco"}
	#

	def create
		deal = current_user.deals_as_creator.new params_permit
		# if !current_user.is_gold && current_user.deals_as_creator.count >= 15
		# 	render status: 411, json: {message: "No se pudo crear el negocio", errors: "Para crear más negocios debes actualizar tu plan a GOLD.", need_gold: true}
		# 	return
		# end
		#TODO: Cambiar de acuerda a logica de dueños y usuarios de negocios
		deal.user_id = current_user.id
		deal.priority = 9999;
		deal.commission = 0 if deal.commission < 0
		if deal.save
			if (deal.person_id.nil? || deal.person_id == "") && !params[:person_name].nil?
				person = current_user.people.create name: params[:person_name]
				deal.update_attribute :person_id, person.id
				# person.update_counts
			end
			deal.update_counts

			HistoryLog.create_for current_user, deal, "Ha creado el negocio #{deal.title}"

			render status: 200, json: {message: "Negocio creado correctamente", id: deal.id}
		else
			render status: 411, json: {message: "No se pudo crear el negocio", errors: deal.errors.full_messages.to_sentence}
		end
	end


	##
	# Actualiza un negocio sobre el usuario en sesión
	#
	# <b>PUT: /api/v1/deals/<id>.json</b>
	#
	# === Params:
	#   user_uuid - Usuario UUID
	#   user_token - Usuario Token de autenticación
	#   deal - {title: "Brand new Master Balls", user_id: 101, value: 150000, tax: 10, total: 165000, commission: 25%, currency: "COP", stage_id: 190, person_id: 151, priority: 1}
	#
	# == Ejemplos
	#
	# === Status Ok
	#   => 200
	#
	# === Respuesta
	#   => {"message": "Negocio actualizado correctamente"}, id: 1
	#
	# === Status Sin autorización
	#   => 422
	#
	# === Respuesta
	#   => {"message": "Necesitas iniciar sesión o registrarte para continuar"}
	#
	# === Status No encontrado
	#   => 411
	#
	# === Respuesta
	#   => {"message": "No se pudo actualizar el negocio", errors: "Título no puede estar en blanco"}
	#

	def update
		deal = current_user.deals_as_creator.find params[:id]
		if deal.update params_permit

			unless params[:priority].nil?
				deals = deal.stage.deals
				params[:priority].each_with_index do |id, i|
					_deal = deals.find_by_id(id)
					unless _deal.nil?
						deal.priority = i if _deal.id == deal.id
						_deal.update_attribute(:priority, i)
					end
				end
			end

			if (deal.person_id.nil? || deal.person_id == "") && !params[:person_name].nil?
				person = current_user.people.create name: params[:person_name]
				deal.update_attribute :person_id, person.id
				# person.update_counts
			end

			deal.update_counts

			deal.previous_changes.each do |key, value|
				if key != "updated_at" && key != "status" && key != "stage_id" && key != "priority" && key != "person_id"
					HistoryLog.create_for current_user, deal, "Ha actualizado #{Deal.human_attribute_name(key)} del negocio, antes: #{value.first}, despues: #{value.last}"
				elsif key == "stage_id"
					HistoryLog.create_for current_user, deal, "Ha pasado el negocio #{deal.title} a la etapa #{deal.stage.name}"
				elsif key == "person_id"
					HistoryLog.create_for current_user, deal, "Ha cambiado el contacto del negocio por #{deal.person.name}"
				end
			end

			render status: 200, json: {message: "Negocio actualizado correctamente", id: deal.id, stage_id: deal.stage_id, old_stage_id: params[:old_stage_id], priority: deal.priority}
		else
			render status: 411, json: {message: "No se pudo actualizar el negocio", errors: deal.errors.full_messages.to_sentence}
		end
	end


	##
	# Elimina un negocio sobre el usuario en sesión
	#
	# <b>DELETE: /api/v1/deals/<id>.json</b>
	#
	# === Params:
	#   user_uuid - Usuario UUID
	#   user_token - Usuario Token de autenticación
	#   id - ID
	#
	# == Ejemplos
	#
	# === Status Ok
	#   => 200
	#
	# === Respuesta
	#   => {"message": "Negocio eliminado correctamente"}
	#
	# === Status Sin autorización
	#   => 422
	#
	# === Respuesta
	#   => {"message": "Necesitas iniciar sesión o registrarte para continuar"}
	#
	# === Status No encontrado
	#   => 411
	#
	# === Respuesta
	#   => {"message": "No se pudo eliminar el negocio"}
	#

	def destroy
		deal = current_user.deals.find params[:id]
		if deal.status == 1
			deal.update_attribute :status, 0
			HistoryLog.create_for current_user, deal, "Ha restaurado el negocio #{deal.title}"
			render status: 200, json: {message: "Negocio restaurado correctamente"}
		else
			deal.update_attribute :status, 1
			HistoryLog.create_for current_user, deal, "Ha archivado el negocio #{deal.title}"
			render status: 200, json: {message: "Negocio pasado a la papelera correctamente"}
		end
	end


	##
	# Cambiar una negocio de estado sobre el usuario en sesión
	#
	# <b>POST: /api/v1/deals/<id>/change_status.json</b>
	#
	# === Params:
	#   user_uuid - Usuario UUID
	#   user_token - Usuario Token de autenticación
	#   id - ID
	#   status - Estado a cambiar (0 -> Pendientes, 1 -> Atrazado, 2 -> Realizados)
	#
	# == Ejemplos
	#
	# === Status Ok
	#   => 200
	#
	# === Respuesta
	#   => {"message": "Actividad pasada de estado correctamente"}
	#
	# === Status Sin autorización
	#   => 422
	#
	# === Respuesta
	#   => {"message": "Necesitas iniciar sesión o registrarte para continuar"}
	#
	# === Status No encontrado
	#   => 411
	#
	# === Respuesta
	#   => {"message": "No se pudo cambiar de estado la actividad"}
	#

	def change_status
		unless ["0", "1", "2", "3", 0, 1, 2, 3].include? params[:status]
			render status: 411, json: {message: "Estado no permitido"}
			return
		end
		deal = current_user.deals.find params[:id]
		deal.update_attribute :status, params[:status]

		deal.update_actual_status_time

		deal.update_counts

		HistoryLog.create_for current_user, deal, "Ha pasado a: #{deal.get_status_name} el negocio#{deal.title}"

		render status: 200, json: {message: "Negocio pasada de estado correctamente"}
	end


	##
	# Invita un usuario a un negocio sobre el usuario en sesión
	#
	# <b>POST: /api/v1/deals/<id>/invite_member.json</b>
	#
	# === Params:
	#   user_uuid - Usuario UUID
	#   user_token - Usuario Token de autenticación
	#   id - ID
	#   funnel_id - ID del embudo
	#	user_id - ID del usuario a adicionar
	#
	# == Ejemplos
	#
	# === Status Ok
	#   => 200
	#
	# === Respuesta
	#   => {"message": "Usuario adicionado al negocio correctamente"}
	#
	# === Status Sin autorización
	#   => 422
	#
	# === Respuesta
	#   => {"message": "Necesitas iniciar sesión o registrarte para continuar"}
	#
	# === Status No encontrado
	#   => 411
	#
	# === Respuesta
	#   => {"message": "No se pudo adicionar al usuario"}
	#

	def invite_member
		permission = params[:permission]
		if permission.nil?
			permission = Funnel::PERMISSION_READ_ALL
		end
		funnel = current_user.funnels_as_member.has_permission([Funnel::PERMISSION_OWNER, Funnel::PERMISSION_WRITE_ALL]).find params[:funnel_id]
		deal = current_user.deals_as_creator.find params[:id]

		user = User.find_by_id params[:user_id]
		unless user.nil?
			deal.user_deals.create(user_id: params[:user_id], permission: permission)
		else
			render status: 411, json: {message: "El usuario no ha sido invitado al embudo"}
			return
		end

		MainMailer.invite(current_user, user, funnel)
		HistoryLog.create_for current_user, deal, "Ha adicionado al negocio #{deal.title} a #{user.name}"
		render status: 200, json: {message: "Usuario adicionado a negocio correctamente"}
	end


	##
	# Remueve un usuario de un negocio sobre el usuario en sesión
	#
	# <b>POST: /api/v1/deals/<id>/remove_member.json</b>
	#
	# === Params:
	#   user_uuid - Usuario UUID
	#   user_token - Usuario Token de autenticación
	#   id - ID
	#	user_id - ID del usuario a adicionar
	#
	# == Ejemplos
	#
	# === Status Ok
	#   => 200
	#
	# === Respuesta
	#   => {"message": "Usuario removido del negocio correctamente"}
	#
	# === Status Sin autorización
	#   => 422
	#
	# === Respuesta
	#   => {"message": "Necesitas iniciar sesión o registrarte para continuar"}
	#
	# === Status No encontrado
	#   => 411
	#
	# === Respuesta
	#   => {"message": "No se pudo remover el usuario"}
	#

	def remove_member
		funnel = current_user.funnels_as_member.has_permission([Funnel::PERMISSION_OWNER, Funnel::PERMISSION_WRITE_ALL]).find params[:funnel_id]
		deal = current_user.deals_as_creator.find params[:id]
		user_funnel = deal.user_deals.find_by_user_id(params[:user_id])

		unless user_funnel.nil?

			user_funnel.destroy
			HistoryLog.create_for current_user, deal, "Ha sacado del negocio #{deal.title} a #{user_funnel.user.name}"
			render status: 200, json: {message: "Usuario removido de embudo correctamente"}
		else
			render status: 200, json: {message: "No se pudo remover el usuario"}
		end
	end


	private

	##
	# Parametros permitidos en las peticiones <b>#create, #update</b>

	def params_permit
		params.require(:deal).permit(:title, :user_id, :value, :tax, :total, :commission, :currency, :stage_id, :person_id, :priority, :estimated_close_date, extra_field_deals_attributes: [:value, :kind, :extra_field_id])
	end

	def reorder()

	end

end
