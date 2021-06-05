class Blog::PostsController < ApplicationController
	layout "landing/layouts/application"
	
	def index 
		@posts = Post.all.page(params[:page]).per(10).order("date DESC")
	end
	
	def show 
		@post = Post.find params[:id]
	end
end
