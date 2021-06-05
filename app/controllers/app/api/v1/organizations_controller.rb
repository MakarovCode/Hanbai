##
# Esta clase representa las organizaciones de un usuario.

class App::Api::V1::OrganizationsController < App::Api::ApiController


	#	autocomplete :name
	def autocomplete
		unless params[:term].nil?
			@companies = current_user.companies.actives.by_term params[:term]
		else
			@companies = current_user.companies.actives.order(name: :asc)
		end
	end

	##
	# Devuelve la lista de organizaciones del usuario en sesión
	#
	# <b>GET: /api/v1/organizations.json</b>
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
	#			"id": 1,
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
		@companies = current_user.companies.actives
	end


	##
	# Devuelve una organizacion del usuario en sesión por un ID
	#
	# <b>GET: /api/v1/organizations/<id>.json</b>
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
	#   => {
	#	     "id": 1,
	#		  "name": "Pokemon Company",
	#		  "address": "Tokio Avn 231",
	#		  "notes": "They need a brand new Master Ball",
	#		  "people_count": 0,
	#		  "open_deals_count": 0,
	#		  "won_deals_count": 0,
	#		  "closed_deal_count": 0,
	#		  "activities_count": 0,
	#		  "done_activities_count": 0,
	#		  "undone_activities_count": 0
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
		@companies = current_user.companies.find params[:id]
		render "index"
	end


	##
	# Crea una organización sobre el usuario en sesión
	#
	# <b>POST: /api/v1/organizations.json</b>
	#
	# === Params:
	#   user_uuid - Usuario UUID
	#   user_token - Usuario Token de autenticación
	#   company - {name: "Pokemon Company", address: "Tokio Avn 213", notes_attributes: [{text: "your awesome note here"}]}
	#
	# == Ejemplos
	#
	# === Status Ok
	#   => 200
	#
	# === Respuesta
	#   => {"message": "Organización creada correctamente", id: 1}
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
	#   => {"message": "No se pudo crear la organización", errors: "Nombre no puede estar en blanco"}
	#

	def create
		company = current_user.companies.new create_params_permit
		if company.save
			render status: 200, json: {message: "Organización creada correctamente", id: company.id}
		else
			render status: 411, json: {message: "No se pudo crear la organización", errors: company.errors.full_messages.to_sentence}
		end
	end


	##
	# Actualiza una organización sobre el usuario en sesión
	#
	# <b>PUT: /api/v1/organizations/<id>.json</b>
	#
	# === Params:
	#   user_uuid - Usuario UUID
	#   user_token - Usuario Token de autenticación
	#   company - {name: "Pokemon Company", address: "Tokio Avn 213"}
	#
	# == Ejemplos
	#
	# === Status Ok
	#   => 200
	#
	# === Respuesta
	#   => {"message": "Organización creada correctamente", id: 1}
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
	#   => {"message": "No se pudo actualizar la organización", errors: "Nombre no puede estar en blanco"}
	#

	def update
		company = current_user.companies.find params[:id]
		if company.update update_params_permit
			render status: 200, json: {message: "Organización actualizada correctamente", id: company.id}
		else
			render status: 411, json: {message: "No se pudo actualizar la organización", errors: company.errors.full_messages.to_sentence}
		end
	end


	##
	# Elimina una organización sobre el usuario en sesión
	#
	# <b>DELETE: /api/v1/organizations/<id>.json</b>
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
	#   => {"message": "Organización eliminada correctamente"}
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
	#   => {"message": "No se pudo eliminar la organización"}
	#

	def destroy
		company = current_user.companies.find params[:id]
		if company.status == 1
			company.update_attribute :status, 0
			render status: 200, json: {message: "Organización restaurada correctamente"}
		else
			company.update_attribute :status, 1
			render status: 200, json: {message: "Organización pasada a la papelera correctamente"}
		end
	end


	##
	# Importa de excel las compañías
	#
	# <b>POST: /api/v1/organizations/import.json</b>
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
	#   => {"message": "Organizaciones importadas correctamente"}
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
	#   => {"message": "No se pudo eliminar la organización"}
	#

	def import
		require 'csv'
		require 'iconv'

		begin
			resp = Company.xls_uploader(params[:file], current_user)

			if resp.length > 1
				resp = resp.to_s.gsub(",","").gsub("[","").gsub("]","").gsub('"',"")

				render status: 411, json: {message: "No se pudieron importar los registros", errors: "#{resp}"}
			else
				render status: 200, json: {message: "Organizaciones importadas correctamente"}
			end
		rescue
			render status: 411, json: {message: "No se pudieron importar los registros", errors: "Debes seleccionar un archivo válido"}
		end

	end


	private

	##
	# Parametros permitidos en las peticiones <b>#create, #update</b>

	def create_params_permit
		params.require(:company).permit(:name, :address, notes_attributes: [:text])
	end

	def update_params_permit
		params.require(:company).permit(:name, :address)
	end

end
