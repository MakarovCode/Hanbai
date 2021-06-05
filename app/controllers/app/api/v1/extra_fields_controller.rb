##
# Esta clase representa los campos extra.

class App::Api::V1::ExtraFieldsController < App::Api::ApiController

	##
	#TODO: DOCUMENTAR
	# Devuelve la lista de log de embudos, negocios, actividades
	#
	# <b>GET: /api/v1/logs.json</b>
	#
	# === Params:
	#   user_uuid - Usuario UUID
	#   user_token - Usuario Token de autenticación
	#   funnel_id - Id del embudo
	#   deal_id - El caso de filtrar el log por un negocio
	#   activity_id - El caso de filtrar el log por una actividad
	#
	# == Ejemplos
	#
	# === Status Ok
	#   => 200
	#
	# === Respuesta
	#   => [
	#		  {
	#			"id": 1,
	#			"action_text": 1,
	#			"funnel_id": 1,
	#			"deal_id": 1,
	#			"activity_id": 1
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
		if params[:funnel_id]
			funnel = current_user.funnels_as_member.find params[:funnel_id]
			@extra_fields = funnel.extra_fields.actives
		else
			@extra_fields = current_user.extra_fields.where(funnel_id: nil).actives
		end
	end

	def create
		extra_field = current_user.extra_fields.new permit_params
		if extra_field.save
			render status: 200, json: {message: "Campo creado correctamente", extra_field_id: extra_field.id}
		else
			render status: 411, json: {message: "No se pudo crear el capmo", errors: extra_field.errors.full_messages.to_sentence}
		end
	end

	def update
		extra_field = current_user.extra_fields.find params[:id]
		if extra_field.update permit_params
			render status: 200, json: {message: "Campo actualizado correctamente"}
		else
			render status: 411, json: {message: "No se pudo actualizar el campo", errors: extra_field.errors.full_messages.to_sentence}
		end
	end

	def destroy
		extra_field = current_user.extra_fields.find params[:id]
		extra_field.destroy
		render status: 200, json: {message: "Campo archivado correctamente"}
	end

	private

	def permit_params
		params.require(:extra_field).permit(:name, :kind, :object_type, :funnel_id)
	end


end
