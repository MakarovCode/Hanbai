class Landing::LandingController < ApplicationController
	layout "landing/layouts/application"

	before_action :new_contact

	def new_contact
		@contact = Contact.new
	end
end
