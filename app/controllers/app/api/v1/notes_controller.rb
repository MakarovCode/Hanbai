##
# Esta clase representa los embudos de un usuario.

class App::Api::V1::NotesController < App::Api::ApiController

	##
	# Devuelve la lista de notas del usuario en sesión
	#
	# <b>GET: /api/v1/notes.json</b>
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
		@notes = current_user.notes
	end


	##
	# Devuelve un nota del usuario en sesión por un ID
	#
	# <b>GET: /api/v1/stages/<id>.json</b>
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
		@notes = current_user.notes.find params[:id]
		render "index"
	end


	##
	# Crea un nota sobre el usuario en sesión
	#
	# <b>POST: /api/v1/notes.json</b>
	#
	# === Params:
	#   user_uuid - Usuario UUID
	#   user_token - Usuario Token de autenticación
	#   note - {company_id: 1, person_id: 2, text: "Tu nota fantástica"}
	#
	# == Ejemplos
	#
	# === Status Ok
	#   => 200
	# 
	# === Respuesta
	#   => {"message": "Nota creada correctamente", id: 1} 
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
	#   => {"message": "No se pudo crear la nota", errors: "Texto no puede estar en blanco"}
	#

	def create 

		note = current_user.notes.new params_permit

		if note.save
			render status: 200, json: {message: "Nota creada correctamente", id: note.id}
		else
			render status: 411, json: {message: "No se pudo crear la nota", errors: note.errors.full_messages.to_sentence}
		end
	end


	##
	# Actualiza un nota sobre el usuario en sesión
	#
	# <b>PUT: /api/v1/notes/<id>.json</b>
	#
	# === Params:
	#   user_uuid - Usuario UUID
	#   user_token - Usuario Token de autenticación
	#   note - {company_id: 1, person_id: 2, text: "Tu nota fantástica"}
	#
	# == Ejemplos
	#
	# === Status Ok
	#   => 200
	# 
	# === Respuesta
	#   => {"message": "nota actualizado correctamente", id: 1} 
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
	#   => {"message": "No se pudo actualizar la nota", errors: "Nombre no puede estar en blanco"}
	#

	def update

		note = current_user.notes.find params[:id]

		if note.update params_permit
			render status: 200, json: {message: "Nota actualizada correctamente", id: note.id}
		else
			render status: 411, json: {message: "No se pudo actualizar la nota", errors: note.errors.full_messages.to_sentence}
		end
	end


	##
	# Elimina un nota sobre el usuario en sesión
	#
	# <b>DELETE: /api/v1/notes/<id>.json</b>
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
	#   => {"message": "Nota eliminada correctamente"} 
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
	#   => {"message": "No se pudo eliminar la nota"}
	#

	def destroy 
		note = funnel.notes.find params[:id]
		note.destroy
		render status: 200, json: {message: "Nota eliminada correctamente"}
	end


	private

	##
	# Parametros permitidos en las peticiones <b>#create, #update</b>

	def params_permit
		params.require(:stage).permit(:text, :company_id, :person_id)
	end

end