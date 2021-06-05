##
# Esta clase representa el usuario de la aplicación.

class App::ActivitiesController < App::AppController

	def index 
		@activity = Activity.new
	end

end