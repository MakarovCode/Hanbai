##
# Esta clase representa los contactos de un usuario.

class App::Api::V1::PeopleController < App::Api::ApiController

	def autocomplete
		@people = current_user.people.actives.by_term params[:term]
	end

	##
	# Devuelve la lista de contactos del usuario en sesión
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
	#			"id": 1,
	#			"company_id": 1,
	#			"name": "Pikachu",
	#			"notes": "Is looking for ash",
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
		if params[:only_trash].nil?
			@people = current_user.people.actives
		else
			@people = current_user.people.inactives
		end
	end


	##
	# Devuelve un contacto del usuario en sesión por un ID
	#
	# <b>GET: /api/v1/people/<id>.json</b>
	#
	# === Params:
	#   user_uuid - Usuario UUID
	#   user_token - Usuario Token de autenticación
	#   full_data - Si true envía los Attachments (Archivos adjuntos), Deals (negocios) y Activities (actividades).
	#
	# == Ejemplos
	#
	# === Status Ok
	#   => 200
	#
	# === Respuesta
	#   => {
	#		  "id": 1,
	#		  "company_id": 1,
	#		  "name": "Pikachu",
	#		  "notes": "Is looking for ash",
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
		@people = current_user.people.find params[:id]
		render "index"
	end


	##
	# Crea un contacto sobre el usuario en sesión
	#
	# <b>POST: /api/v1/people.json</b>
	#
	# === Params:
	#   user_uuid - Usuario UUID
	#   user_token - Usuario Token de autenticación
	#   person - {name: "Pikachu", company_id: 151, notes_attributes: [{text: "your awesome note here"}]}
	#
	# == Ejemplos
	#
	# === Status Ok
	#   => 200
	#
	# === Respuesta
	#   => {"message": "Contacto creado correctamente", id: 1}
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
	#   => {"message": "No se pudo crear el contacto", errors: "Nombre no puede estar en blanco"}
	#

	def create
		person = current_user.people.new create_params_permit

		if person.save

			if person.company_id.nil? && !params[:person_company_name].nil?
				company = current_user.companies.create name: params[:person_company_name]
				person.update_attribute :company_id, company.id
			end

			person.update_counts

			render status: 200, json: {message: "Contacto creado correctamente", id: person.id}
		else
			render status: 411, json: {message: "No se pudo crear la persona", errors: person.errors.full_messages.to_sentence}
		end
	end


	##
	# Actualiza un contacto sobre el usuario en sesión
	#
	# <b>PUT: /api/v1/people/<id>.json</b>
	#
	# === Params:
	#   user_uuid - Usuario UUID
	#   user_token - Usuario Token de autenticación
	#   person - {name: "Pikachu", company_id: 151, notes_attributes: [{text: "your awesome note here"}]}
	#
	# == Ejemplos
	#
	# === Status Ok
	#   => 200
	#
	# === Respuesta
	#   => {"message": "Contacto creado correctamente", id: 1}
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
	#   => {"message": "No se pudo actualizar el contacto", errors: "Nombre no puede estar en blanco"}
	#

	def update
		person = current_user.people.find params[:id]
		if person.update update_params_permit

			if person.company_id.nil? && !params[:person_company_name].nil?
				company = current_user.companies.create name: params[:person_company_name]
				person.update_attribute :company_id, company.id
			end

			person.update_counts

			render status: 200, json: {message: "Contacto actualizado correctamente", id: person.id, company: {id: person.company_id, name: person.company.nil? ? "" : person.company.name}}
		else
			render status: 411, json: {message: "No se pudo actualizar el contacto", errors: person.errors.full_messages.to_sentence}
		end
	end


	##
	# Elimina un contacto sobre el usuario en sesión
	#
	# <b>DELETE: /api/v1/people/<id>.json</b>
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
	#   => {"message": "Contacto eliminado correctamente"}
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
	#   => {"message": "No se pudo eliminar el contacto"}
	#

	def destroy
		person = current_user.people.find params[:id]
		if person.status == 1
			person.update_attribute :status, 0
			render status: 200, json: {message: "Contacto restaurado correctamente"}
		else
			person.update_attribute :status, 1
			render status: 200, json: {message: "Contacto pasado a la papelera correctamente"}
		end
	end


	##
	# Importa de excel las personas
	#
	# <b>POST: /api/v1/people/import.json</b>
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
	#   => {"message": "Contactos importadas correctamente"}
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
	#   => {"message": "No se pudo eliminar el contacto"}
	#

	def import
		require 'csv'
		require 'iconv'

		begin
			resp = Person.xls_uploader(params[:file], current_user)

			if resp.length > 1
				resp = resp.to_s.gsub(",","").gsub("[","").gsub("]","").gsub('"',"")

				render status: 411, json: {message: "No se pudieron importar los registros", errors: "#{resp}"}
			else
				render status: 200, json: {message: "Contactos importadas correctamente"}
			end
		rescue
			render status: 411, json: {message: "No se pudieron importar los registros", errors: "Debes seleccionar un archivo válido"}
		end

	end

	def create_phone
		person = current_user.people.find params[:id]

		phone = params[:phone]
		kind = "Personal"
		if params[:phone].include?(",")
			splitted = params[:phone].gsub(" ", "").split(",")
			phone = splitted[0]
			unless splitted[1].nil?
				kind = splitted[1].camelcase
			else
				kind = "Personal"
			end
		end
		if kind.nil? || kind == ""
			kind = "Personal"
		else
			kind.camelcase
		end

		_phone = person.person_phones.create phone: phone, kind: kind
		render status: 200, json: {message: "Teléfono eliminado correctamente", phone: {id: _phone.id, phone: phone, kind: kind}}
	end

	def delete_phone
		person = current_user.people.find params[:id]
		phone = person.person_phones.find params[:phone_id]

		phone.destroy
		render status: 200, json: {message: "Teléfono eliminado correctamente"}
	end

	def create_email
		person = current_user.people.find params[:id]

		email = params[:email]
		kind = "Personal"
		if params[:email].include?(",")
			splitted = params[:email].gsub(" ", "").split(",")
			email = splitted[0]
			unless splitted[1].nil?
				kind = splitted[1].camelcase
			else
				kind = "Personal"
			end
		end
		if kind.nil? || kind == ""
			kind = "Personal"
		else
			kind.camelcase
		end

		_email = person.person_emails.create email: email, kind: kind
		render status: 200, json: {message: "Email eliminado correctamente", email: {id: _email.id, email: email, kind: kind}}
	end

	def delete_email
		person = current_user.people.find params[:id]
		email = person.person_emails.find params[:email_id]

		email.destroy
		render status: 200, json: {message: "Email eliminado correctamente"}
	end

	def create_address
		person = current_user.people.find params[:id]

		address = params[:address]
		kind = "Personal"
		if params[:address].include?(",")
			splitted = params[:address].gsub(" ", "").split(",")
			address = splitted[0]
			unless splitted[1].nil?
				kind = splitted[1].camelcase
			else
				kind = "Personal"
			end
		end
		if kind.nil? || kind == ""
			kind = "Personal"
		else
			kind.camelcase
		end

		_address = person.person_addresses.create address: address, kind: kind
		render status: 200, json: {message: "Dirección eliminada correctamente", address: {id: _address.id, address: address, kind: kind}}
	end

	def delete_address
		person = current_user.people.find params[:id]
		address = person.person_addresses.find params[:address_id]

		address.destroy
		render status: 200, json: {message: "Dirección eliminada correctamente"}
	end


	private

	##
	# Parametros permitidos en las peticiones <b>#create, #update</b>

	def create_params_permit
		params.require(:person).permit(:name, :role, :company_id, notes_attributes: [:text], person_phones_attributes: [:phone, :kind], person_emails_attributes: [:email, :kind], person_addresses_attributes: [:address, :kind], extra_field_contacts_attributes: [:kind, :value, :extra_field_id])
	end

	def update_params_permit
		params.require(:person).permit(:id, :role, :name, :company_id)
	end

end
