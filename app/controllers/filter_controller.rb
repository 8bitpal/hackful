class FilterController < ApplicationController
	check_authorization
	load_and_authorize_resource
	
	rescue_from CanCan::AccessDenied do |exception|
		flash[:error] = exception.message
		session[:user_return_to] = request.url
		redirect_to new_user_session_path
	end
end
