class Company < ApplicationRecord
	belongs_to :user

	has_many :notes
	has_many :people

	accepts_nested_attributes_for :notes

	validates :name, :user_id, presence: true

	def self.actives 
		where status: [nil, 0]
	end

	def self.inactives 
		where status: 1
	end
	
	def self.by_term(term)
		where("lower(unaccent(name)) iLIKE('%#{I18n.transliterate(term.downcase)}%')")
	end

	def self.xls_uploader(file, user)

		spreadsheet = open_spreadsheet(file)
		header = spreadsheet.row(1)
		header_in = header.clone

		header_resp = []
		puts "==============HEADER======#{header}"
		header.map!{|c| I18n.transliterate(c.downcase.strip)} 


		error = ["Tienes error en los siguientes titulos de columnas"]
		validators = [
			{key: "name", required: true, model: nil, compare: nil, accepteds: ["name", "nombre"], error: "<br/> No encontramos la columna <b> Nombre </b> por favor revisa ortografía" },
			{key: "address", required: true, model: nil, compare: nil, accepteds: ["address", "direccion", "Direccion", "Dirección", "dirección"], error: "<br/> No encontramos la columna <b> Dirección </b> por favor revisa ortografía" }
			]

		validators.each do |validator|

			valid = false

			validator[:accepteds].each do |casse|
				valid = true if header.include?(casse)
				if valid
					# @header_resp = [validator[:key] => casse]
					# header_resp = [validator[:key] => casse]
					aux = Hash[header.map.with_index.to_a]
					header[aux[casse]] = validator[:key] # CAMBIA EL NOMBRE DE LOS TITULOS DE COLUMNAS
					break
				end

			end
			if !valid
				error << validator[:error]
			end
		end


		#   2 PARTE 
		if error.length == 1
			error = ["Tienes error en las siguientes filas"] 

			(2..spreadsheet.last_row).each do |i|
				row = Hash[[header, spreadsheet.row(i)].transpose]
				puts "=======ROW=A======#{row}"
				theNames = row["nombre"]

				valid = false
				col = 0
				header.each do |h|
					required = false
					model = nil
					compare = nil
					compare_doc = nil
					type_doc = nil
					validators.each do |validator|
						if validator[:key] == h 
							required = validator[:required]
							model = validator[:model]
							compare = validator[:compare]

							break
						end
					end
					#               
					if !row[h].nil? && !compare.nil?
						unless compare.include?(row[h].downcase)                          
							error << "En la fila #{i}  de la columna #{header_in[col]} el dato #{row[h]} no existe en nuestra base de datos"
						end
					end
					#               
					col += 1
				end

				company = user.companies.create(
					name: row["name"].to_s,
					address: row["address"].to_s
					)
			end
		end  
		return error

	end

	def self.open_spreadsheet(file)
		case File.extname(file.original_filename)
		when ".csv"
			Roo::CSV.new(file.path)
		when ".xls" 
			Roo::Excel.new(file.path)
		when ".xlsx" 
			Roo::Excelx.new(file.path)
		else 
			raise "Tipo de Archivo desconocido: #{file.original_filename}"
		end
	end

end
