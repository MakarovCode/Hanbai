class App::AppController < ApplicationController
	
	layout "app/layouts/application"
	
	before_action :authenticate_user!

end
