##
# Esta clase representa los embudos de un usuario.

class App::Api::V1::FunnelsController < App::Api::ApiController

	##
	# Devuelve la lista de embudos del usuario en sesión
	#
	# <b>GET: /api/v1/people.json</b>
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
	#			"id": 2,
	#			"name": "Pikachu",
	#			"color": "#ff0000"
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
		@funnels = current_user.funnels_as_member.includes(:users).actives
	end


	##
	# Devuelve un embudo del usuario en sesión por un ID
	#
	# <b>GET: /api/v1/funnels/<id>.json</b>
	#
	# === Params:
	#   user_uuid - Usuario UUID
	#   user_token - Usuario Token de autenticación
	#   full_data - Si true envía los Stages (etapas), Deals (negocios) y Activities (actividades).
	#
	# == Ejemplos
	#
	# === Status Ok
	#   => 200
	#
	# === Respuesta
	#	=>	{
	#		   "id": 2,
	#		   "name": "Pikachu",
	#		   "color": "#ff0000"
	#		}
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
		@stats = params[:stats] == "true"
		@funnels = current_user.funnels_as_member.find params[:id]
		if @stats == true
			@deals = Deal.by_funnels(@funnels.id)
		end
		render "index"
	end


	##
	# Crea un embudo sobre el usuario en sesión
	#
	# <b>POST: /api/v1/funnels.json</b>
	#
	# === Params:
	#   user_uuid - Usuario UUID
	#   user_token - Usuario Token de autenticación
	#   funnel - {name: "Pokeballs Business", color: "#ff0000"}
	#	default_stages - Si true crea las etapas por defecto (Contacto, Contacto establecido, Establecer necesidades, Propuesta)
	#
	# == Ejemplos
	#
	# === Status Ok
	#   => 200
	#
	# === Respuesta
	#   => {"message": "Embudo creado correctamente", id: 1}
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
	#   => {"message": "No se pudo crear el embudo", errors: "Nombre no puede estar en blanco"}
	#

	def create
		funnel = current_user.funnels.new params_permit
		funnel.color = "#3498DB"
		# if !current_user.is_gold && current_user.funnels.count >= 1
		# 	render status: 411, json: {message: "No se pudo crear el embudo", errors: "Para crear más embudos debes actualizar tu plan a GOLD.", need_gold: true}
		# 	return
		# end
		if funnel.save
			if params[:default_stages] == true
				funnel.stages.create([{name: "Contacto", priority: 1}, {name: "Contacto establecido", priority: 2}, {name: "Establecer necesidades", priority: 3}, {name: "Propuesta", priority: 4}])
			end

			HistoryLog.create_for current_user, funnel, "Ha creado el embudo #{funnel.name}"
			funnel.stages.each do |stage|
				HistoryLog.create_for current_user, stage, "Ha creado la etapa #{stage.name} en el orden #{stage.priority}"
			end

			current_user.user_funnels.create(funnel_id: funnel.id, permission: "owner")
			render status: 200, json: {message: "Embudo creado correctamente", id: funnel.id}
		else
			render status: 411, json: {message: "No se pudo crear el embudo", errors: funnel.errors.full_messages.to_sentence}
		end
	end


	##
	# Actualiza un embudo sobre el usuario en sesión
	#
	# <b>PUT: /api/v1/funnels/<id>.json</b>
	#
	# === Params:
	#   user_uuid - Usuario UUID
	#   user_token - Usuario Token de autenticación
	#   funnel - {name: "Pokeballs Business", color: "#ff0000"}
	#
	# == Ejemplos
	#
	# === Status Ok
	#   => 200
	#
	# === Respuesta
	#   => {"message": "Embudo actualizado correctamente", id: 1}
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
	#   => {"message": "No se pudo actualizar el embudo", errors: "Nombre no puede estar en blanco"}
	#

	def update
		funnel = current_user.funnels_as_member.has_permission([Funnel::PERMISSION_OWNER, Funnel::PERMISSION_WRITE_ALL]).find params[:id]
		if funnel.update params_permit
			funnel.previous_changes.each do |key, value|
				if key != "updated_at" && key != "status"
					HistoryLog.create_for current_user, funnel, "Ha actualizado #{Funnel.human_attribute_name(key)} de embudo, antes: #{value.first}, despues: #{value.last}"
				end
			end
			render status: 200, json: {message: "Embudo actualizado correctamente", id: funnel.id}
		else
			render status: 411, json: {message: "No se pudo actualizar el embudo", errors: funnel.errors.full_messages.to_sentence}
		end
	end


	##
	# Elimina un embudo sobre el usuario en sesión
	#
	# <b>DELETE: /api/v1/funnels/<id>.json</b>
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
	#   => {"message": "Embudo eliminado correctamente"}
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
	#   => {"message": "No se pudo eliminar el embudo"}
	#

	def destroy
		funnel = current_user.funnels.find params[:id]
		if funnel.status == 1
			funnel.update_attribute :status, 0
			HistoryLog.create_for current_user, funnel, "Ha restaurado el embudo #{funnel.name}"
			render status: 200, json: {message: "Embudo restaurado correctamente"}
		else
			funnel.update_attribute :status, 1
			HistoryLog.create_for current_user, funnel, "Ha archivado el embudo #{funnel.name}"
			render status: 200, json: {message: "Embudo pasado a la papelera correctamente"}
		end
	end


	##
	# Invita un usuario a un embudo sobre el usuario en sesión
	#
	# <b>POST: /api/v1/funnels/<id>/invite_member.json</b>
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
	#   => {"message": "Usuario invitado a embudo correctamente"}
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
	#   => {"message": "No se pudo invitar al usuario"}
	#

	def invite_member
		permission = params[:permission]
		if permission.nil?
			permission = Funnel::PERMISSION_READ_ALL
		end
		funnel = current_user.funnels_as_member.has_permission([Funnel::PERMISSION_OWNER, Funnel::PERMISSION_WRITE_ALL]).find params[:id]

		user = User.find_by_id params[:user_id]
		unless user.nil?
			funnel.user_funnels.create(user_id: params[:user_id], permission: permission)
			MainMailer.invite(current_user, user, funnel)
			HistoryLog.create_for current_user, funnel, "Ha invitado a participar a #{user.name}"
		else
			funnel.user_funnels.create(tmp_user_id: params[:user_id], permission: permission)
			MainMailer.invite_outsider(current_user, params[:email], funnel)
			HistoryLog.create_for current_user, funnel, "Ha invitado a participar a #{params[:email]}"
		end


		render status: 200, json: {message: "Usuario a embudo invitado correctamente"}
	end


	##
	# Remueve un usuario de un embudo sobre el usuario en sesión
	#
	# <b>POST: /api/v1/funnels/<id>/remove_member.json</b>
	#
	# === Params:
	#   user_uuid - Usuario UUID
	#   user_token - Usuario Token de autenticación
	#   id - ID
	#	  user_id - ID del usuario a adicionar
	#
	# == Ejemplos
	#
	# === Status Ok
	#   => 200
	#
	# === Respuesta
	#   => {"message": "Usuario removido de embudo correctamente"}
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
		funnel = current_user.funnels_as_member.has_permission([Funnel::PERMISSION_OWNER, Funnel::PERMISSION_WRITE_ALL]).find params[:id]
		user_funnel = funnel.user_funnels.find_by_user_id(params[:user_id])

		unless user_funnel.nil?
			user_funnel.destroy
			HistoryLog.create_for current_user, funnel, "Ha sacado del embudo a #{user_funnel.user.name}"
			render status: 200, json: {message: "Usuario removido de embudo correctamente"}
		else
			render status: 200, json: {message: "No se pudo remover el usuario"}
		end
	end


	##
	# Cambiar permisos en miembro en embudo
	#
	# <b>POST: /api/v1/funnels/<id>/change_member_permissions.json</b>
	#
	# === Params:
	#   user_uuid - Usuario UUID
	#   user_token - Usuario Token de autenticación
	#   id - ID
	#	  user_id - ID del usuario a adicionar
	#
	# == Ejemplos
	#
	# === Status Ok
	#   => 200
	#
	# === Respuesta
	#   => {"message": "Permisos cambiados de usuario"}
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
	#   => {"message": "No se pudo cambiar permisos de usuario"}
	#

	def change_member_permissions
		funnel = current_user.funnels_as_member.has_permission([Funnel::PERMISSION_OWNER, Funnel::PERMISSION_WRITE_ALL]).find params[:id]

		if params[:permission] == Funnel::PERMISSION_READ_ALL && funnel.user_funnels.where(permission: [Funnel::PERMISSION_OWNER, Funnel::PERMISSION_WRITE_ALL]).count == 1
			render status: 411, json: {message: "Siempre debe haber al menos un Administrador"}
			return
		end

		user_funnel = funnel.user_funnels.find_by_user_id(params[:user_id])

		unless user_funnel.nil?
			user_funnel.update_attribute :permission, params[:permission]
			HistoryLog.create_for current_user, funnel, "Ha cambiado los permisos de #{user_funnel.user.name} por #{params[:permission]}"
			render status: 200, json: {message: "Permisos cambiado correctamente", permission: {name: params[:permission], permission: params[:permission]}}
		else
			render status: 411, json: {message: "No se pudo cambiar permisos"}
		end
	end


	private

	##
	# Parametros permitidos en las peticiones <b>#create, #update</b>

	def params_permit
		params.require(:funnel).permit(:name, :color)
	end

end
