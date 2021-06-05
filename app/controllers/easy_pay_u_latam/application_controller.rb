module EasyPayULatam
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    layout "app/layouts/application"

    before_action :laod_info

    def laod_info
  		@info = Information.first
  	end
  end
end
