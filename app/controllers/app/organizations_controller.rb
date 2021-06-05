##
# Esta clase representa el usuario de la aplicación.

class App::OrganizationsController < App::AppController

	def index
		@orgnanization = Company.new
		@activity = Activity.new
	end

	def show
		@organization = current_user.companies.find params[:id]
	end

end
