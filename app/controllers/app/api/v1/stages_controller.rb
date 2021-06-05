##
# Esta clase representa los embudos de un usuario.

class App::Api::V1::StagesController < App::Api::ApiController

	##
	# Devuelve la lista de etapa del usuario en sesión
	#
	# <b>GET: /api/v1/stages.json</b>
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
		@full_data = params[:full_data] == "true"
		funnel = current_user.funnels_as_member.find params[:funnel_id]
		@stages = funnel.stages.as_funnel_member(current_user.id).actives.order("priority ASC")
	end


	##
	# Devuelve un etapa del usuario en sesión por un ID
	#
	# <b>GET: /api/v1/stages/<id>.json</b>
	#
	# === Params:
	#   user_uuid - Usuario UUID
	#   user_token - Usuario Token de autenticación
	#   full_data - Si true envía los Deals (negocios) y Activities (actividades).
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
		@stages = Stage.as_funnel_member(current_user.id).find params[:id]
		render "index"
	end


	##
	# Crea un etapa sobre el usuario en sesión
	#
	# <b>POST: /api/v1/stages.json</b>
	#
	# === Params:
	#   user_uuid - Usuario UUID
	#   user_token - Usuario Token de autenticación
	#   stage - {name: "Contacto espablecido", is_standing: false, priority: 1, funnel_id: 1}
	#
	# == Ejemplos
	#
	# === Status Ok
	#   => 200
	#
	# === Respuesta
	#   => {"message": "Etapa creada correctamente", id: 1}
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
	#   => {"message": "No se pudo crear la etapa", errors: "Nombre no puede estar en blanco"}
	#

	def create
		funnel = current_user.funnels_as_member.has_permission([Funnel::PERMISSION_OWNER, Funnel::PERMISSION_WRITE_ALL]).find params[:stage][:funnel_id]

		stage = funnel.stages.new params_permit
		stage.priority = funnel.stages.count - 1
		if stage.save
			HistoryLog.create_for current_user, stage, "Ha creado la etapa #{stage.name}"
			render status: 200, json: {message: "Etapa creada correctamente", id: stage.id}
		else
			render status: 411, json: {message: "No se pudo crear la etapa", errors: stage.errors.full_messages.to_sentence}
		end
	end


	##
	# Actualiza un etapa sobre el usuario en sesión
	#
	# <b>PUT: /api/v1/stages/<id>.json</b>
	#
	# === Params:
	#   user_uuid - Usuario UUID
	#   user_token - Usuario Token de autenticación
	#   stage - {name: "Contacto espablecido", is_standing: false, priority: 1, funnel_id: 1}
	#
	# == Ejemplos
	#
	# === Status Ok
	#   => 200
	#
	# === Respuesta
	#   => {"message": "Etapa actualizada correctamente", id: 1}
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
	#   => {"message": "No se pudo actualizar la etapa", errors: "Nombre no puede estar en blanco"}
	#

	def update
		funnel = current_user.funnels_as_member.has_permission([Funnel::PERMISSION_OWNER, Funnel::PERMISSION_WRITE_ALL]).find params[:stage][:funnel_id]

		stage = funnel.stages.find params[:id]

		if stage.update params_permit
			unless params[:priority].nil?
				funnel = current_user.funnels_as_member.has_permission([Funnel::PERMISSION_OWNER, Funnel::PERMISSION_WRITE_ALL]).find params[:stage][:funnel_id]
				stages = funnel.stages
				params[:priority].each_with_index do |id, i|
					_stage = stages.find_by_id(id)
					unless _stage.nil?
						stage.priority = i if _stage.id == stage.id
						_stage.update_attribute(:priority, i)
						HistoryLog.create_for current_user, stage, "Ha ordenado la etapa #{stage.name} al orden #{i}"
					end
				end
			end

			stage.previous_changes.each do |key, value|
				if key != "updated_at" && key != "status" && key != "priority" && key != "is_standing"
					HistoryLog.create_for current_user, stage, "Ha actualizado #{Stage.human_attribute_name(key)} de la etapa, antes: #{value.first}, despues: #{value.last}"
				end
			end

			render status: 200, json: {message: "Etapa actualizada correctamente", id: stage.id, priority: stage.priority}
		else
			render status: 411, json: {message: "No se pudo actualizar la etapa", errors: stage.errors.full_messages.to_sentence}
		end
	end


	##
	# Elimina un etapa sobre el usuario en sesión
	#
	# <b>DELETE: /api/v1/stages/<id>.json</b>
	#
	# === Params:
	#   user_uuid - Usuario UUID
	#   user_token - Usuario Token de autenticación
	#   id - ID
	#   funnel_id - ID del embudo
	#
	# == Ejemplos
	#
	# === Status Ok
	#   => 200
	#
	# === Respuesta
	#   => {"message": "Etapa eliminada correctamente"}
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
	#   => {"message": "No se pudo eliminar la etapa"}
	#

	def destroy
		funnel = current_user.funnels_as_member.has_permission([Funnel::PERMISSION_OWNER, Funnel::PERMISSION_WRITE_ALL]).find params[:funnel_id]
		stage = funnel.stages.find params[:id]
		if stage.status == 1
			stage.update_attribute :status, 0
			HistoryLog.create_for current_user, stage, "Ha restaurado la etapa #{stage.name}"
			render status: 200, json: {message: "Etapa restaurada correctamente"}
		else
			stage.update_attribute :status, 1
			HistoryLog.create_for current_user, stage, "Ha archivado la etapa #{stage.name}"
			render status: 200, json: {message: "Etapa pasada a la papelera correctamente"}
		end
	end


	private

	##
	# Parametros permitidos en las peticiones <b>#create, #update</b>

	def params_permit
		params.require(:stage).permit(:name, :is_standing, :priority, :funnel_id)
	end

end
