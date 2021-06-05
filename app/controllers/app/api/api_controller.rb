class App::Api::ApiController < ApplicationController	
	acts_as_token_authentication_handler_for User
end
