##
# Esta clase representa los contactos de un usuario.

class App::Api::V1::UsersController < App::Api::ApiController

	def autocomplete
		# TODO: Solo usuarios que esten cargados en el FUNNEL
		@users = User.actives.by_term params[:term]
	end

	##
	# Devuelve la lista de usuarios registrados en la app
	#
	# <b>GET: /api/v1/users.json</b>
	#
	# === Params:
	#   user_uuid - Usuario UUID
	#   user_token - Usuario Token de autenticación
	#   funnel_id - (Opcional) en caso de querer filtrar usuarios adicionados a negocio
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
	#			"name": 1,
	#			"image": "url",
	#			"email": "admin@example.com", (Only if funnel_id)
	#			"profession": "Engineer", (Only if funnel_id)
	#     "funnel_permission" "permission string",
	#     "deal_permission" "permission string"
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
		if params[:funnel_id].nil?
			@users = []
			return
		end
		@funnel = current_user.funnels_as_member.find_by_id params[:funnel_id]
		unless params[:all].nil?
			@users = User.by_term params[:term]
		else
			@users = @funnel.users.by_term params[:term]
		end
	end


end
