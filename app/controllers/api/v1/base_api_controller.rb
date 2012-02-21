class Api::V1::BaseApiController < ApplicationController
	before_filter :set_content_type
	after_filter :set_content_type
	
	rescue_from ActiveRecord::RecordNotFound do |exception|
		render_404
	end
	
	rescue_from Exception do |exception|
		error = {:error => "internal server error", :exception => exception.message, :stacktrace => exception.backtrace}
		render :json => error, :status => 500
	end

	def set_content_type
    	headers['Content-Type'] ||= 'X-SMTH-Api-ver:1'
  	end

	def render_404
		error = {:error => "resource not found"}
		render :json => error, :status => 404
	end

	def render_500
		error = {:error => "internal server error"}
		render :json => error, :status => 500
	end
end