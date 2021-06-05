ActiveAdmin.register Post do

	form do |f|
		f.inputs "Datos del post" do
			f.input :image
			f.input :video
			f.input :title
			f.input :content, as: :html_editor
			f.input :tags, as: :tags
			f.input :author
			f.input :date, as: :datepicker
		end
		f.actions
	end

	controller do
		before_action :permit_params

		def permit_params
			params.permit!
		end
	end


end
