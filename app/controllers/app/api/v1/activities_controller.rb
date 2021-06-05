##
# Esta clase representa los embudos de un usuario.

class App::Api::V1::ActivitiesController < App::Api::ApiController

	##
	# Devuelve la lista de actividades del usuario en sesión
	#
	# <b>GET: /api/v1/activities.json</b>
	#
	# === Params:
	#   user_uuid - Usuario UUID
	#   user_token - Usuario Token de autenticación
	#   statuses - <b>Ej: [0,1]</b> Estados de busqueda de actividades (0 -> Pendientes, 1 -> Atrazado, 2 -> Realizados)
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
		statuses = params[:statuses]
		unless params[:start].nil? && params[:end].nil?
			@activities = current_user.activities.in_range(params[:start], params[:end])
		else
			@activities = current_user.activities.where("date_and_time > ?", (Date.today - 1.month))
		end

		unless statuses.nil?
			if statuses.kind_of?(Array)
				#statuses = [statuses]

			elsif statuses.kind_of?(String)
				statuses = statuses.gsub("[","").gsub("]","").split(",")

			end
			if statuses.include?(0) || statuses.include?("0")
				statuses.push nil
			end
			@activities = current_user.activities.by_statuses(statuses).order("date_and_time DESC")
		end



		unless params[:term].nil?
			@activities = @activities.by_term(params[:term])
		end

	end


	##
	# Devuelve una actividad del usuario en sesión por un ID
	#
	# <b>GET: /api/v1/activities/<id>.json</b>
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
		@activities = current_user.activities.find params[:id]
		render "index"
	end


	##
	# Crea una activitidad sobre el usuario en sesión
	#
	# <b>POST: /api/v1/activities.json</b>
	#
	# === Params:
	#   user_uuid - Usuario UUID
	#   user_token - Usuario Token de autenticación
	#   activity - {title: "Test Pokeballs", activity_type_id: 1, date_and_time: 2017-01-01 8:00 AM, duration: 15, notes: "They like them purple", user_id: 101, deal_id: 50, person_id: 150}
	#
	# == Ejemplos
	#
	# === Status Ok
	#   => 200
	#
	# === Respuesta
	#   => {"message": "Actividad creada correctamente", id: 1}
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
	#   => {"message": "No se pudo crear la actividad", errors: "Título no puede estar en blanco"}
	#

	def create
		activity = current_user.activities_as_creator.new params_permit

		if !current_user.is_gold && current_user.activities_as_creator.count >= 15
			render status: 411, json: {message: "No se pudo crear el embudo", errors: "Para crear más actividades debes actualizar tu plan a GOLD.", need_gold: true}
			return
		end

		if activity.user_id.nil?
			activity.user_id = current_user.id
		end

		if activity.save

			if (activity.person_id.nil? || activity.person_id == "") && !params[:person_name].nil?
				person = current_user.people.create name: params[:person_name]
				activity.update_attribute :person_id, person.id
			end
			activity.update_counts
			# person.update_counts

			if activity.deal.nil?
				HistoryLog.create_for current_user, activity, "Ha creado la actividad #{activity.title}"
			else
				HistoryLog.create_for current_user, activity, "Ha creado la actividad #{activity.title} sobre el negocio #{activity.deal.title}"
			end

			render status: 200, json: {message: "Actividad creada correctamente", id: activity.id}
		else
			render status: 411, json: {message: "No se pudo crear la actividad", errors: activity.errors.full_messages.to_sentence}
		end
	end


	##
	# Actualiza una actividad sobre el usuario en sesión
	#
	# <b>PUT: /api/v1/activities/<id>.json</b>
	#
	# === Params:
	#   user_uuid - Usuario UUID
	#   user_token - Usuario Token de autenticación
	#   activity - {title: "Test Pokeballs", activity_type_id: 1, date_and_time: 2017-01-01 8:00 AM, duration: 15, notes: "They like them purple", user_id: 101, deal_id: 50, person_id: 150}
	#
	# == Ejemplos
	#
	# === Status Ok
	#   => 200
	#
	# === Respuesta
	#   => {"message": "Actividad actualizada correctamente", id: 1}
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
		# TODO: Lo puede destruir si soy el dueño, el creador, y si es una actividad de un negocio de un embudo del que tengo permisos de edición tambien
		activity = current_user.activities.find params[:id]
		if activity.update params_permit

			if (activity.person_id.nil? || activity.person_id == "") && !params[:person_name].nil?
				person = current_user.people.create name: params[:person_name]
				activity.update_attribute :person_id, person.id
				#person.update_counts
			end
			activity.update_counts
			activity.previous_changes.each do |key, value|
				if key != "updated_at" && key != "status"
					HistoryLog.create_for current_user, activity, "Ha actualizado #{Activity.human_attribute_name(key)} de la actividad, antes: #{value.first}, despues: #{value.last}"
				end
			end
			render status: 200, json: {message: "Actividad actualizada correctamente", id: activity.id}
		else
			render status: 411, json: {message: "No se pudo actualizar la actividad", errors: activity.errors.full_messages.to_sentence}
		end
	end


	##
	# Elimina una actividad sobre el usuario en sesión
	#
	# <b>DELETE: /api/v1/activities/<id>.json</b>
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
	#   => {"message": "Actividad eliminada correctamente"}
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
		# TODO: Lo puede destruir si soy el dueño, el creador, y si es una actividad de un negocio de un embudo del que tengo permisos de edición tambien
		activity = current_user.activities.find params[:id]
		if activity.status == 1
			activity.update_attribute :status, 0
			HistoryLog.create_for current_user, activity, "Ha archivado la actividad #{activity.title}"
			render status: 200, json: {message: "Actividad eliminada correctamente"}
		else
			activity.update_attribute :status, 1
			HistoryLog.create_for current_user, activity, "Ha archivado la actividad #{activity.title}"
			render status: 200, json: {message: "Actividad pasada a la papelera correctamente"}
		end
	end


	##
	# Cambiar una actividad de estado sobre el usuario en sesión
	#
	# <b>POST: /api/v1/activities/<id>/change_status.json</b>
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
		activity = current_user.activities.find params[:id]
		activity.update_attribute :status, params[:status]
		activity.update_counts

		HistoryLog.create_for current_user, activity, "Ha pasado a: #{activity.get_status_name} la actividad #{activity.title}"

		render status: 200, json: {message: "Actividad pasada de estado correctamente"}
	end

	private

	##
	# Parametros permitidos en las peticiones <b>#create, #update</b>

	def params_permit
		params.require(:activity).permit(:title, :activity_type_id, :date_and_time, :duration, :notes, :user_id, :deal_id, :person_id, notes_attributes: [:text])
	end

end
