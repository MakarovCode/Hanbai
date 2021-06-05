class ApplicationController < ActionController::Base

	protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
	protect_from_forgery with: :exception, unless: Proc.new { |c| c.request.format == 'application/json' }

	before_action :track_action
	before_action :laod_info
	before_action :configure_permitted_parameters, if: :devise_controller?

	rescue_from ActionController::RoutingError, with: :not_found
	# rescue_from ActionController::UnknownController, with: :not_found
	rescue_from ActiveRecord::RecordNotFound, with: :not_found
	#	rescue_from Exception, with: :exception

	layout "landing/layouts/application"

	protected

	def laod_info
		@info = Information.first
		# EasyPayULatam::Engine.eager_load!
	end

	def track_action
		# Ahoy.geocode = :async
		# ahoy.track_visit
	end

	def not_found
		respond_to do |format|
			format.html { render :file => File.join(Rails.root, 'public', '404.html') }
			format.json { render status: 404, json:  {message: "Recurso no encontrado, revisa tu petición"} }
		end
	end

	def exception
		respond_to do |format|
			format.html { render :file => File.join(Rails.root, 'public', '500.html') }
			format.json { render status: 500, json:  {message: "Ha ocurrido un error inesperado, revisa tu petición"} }
		end
	end

	def after_sign_in_path_for(resource)
		if resource.class.name.to_s == "User"
			app_funnels_path
		else
			admin_dashboard_path(resource)
		end
	end

	def after_sign_out_path_for(resource)
		root_path
	end

	def configure_permitted_parameters
		devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
	end
end
