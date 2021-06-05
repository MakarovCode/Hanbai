##
# Esta clase representa el usuario de la aplicación.

class App::PeopleController < App::AppController

	def index
		@person = Person.new
		@activity = Activity.new
		@companies = current_user.companies.actives.order("name ASC")
	end

	def show

	end

end
