class Api::ApplicationController < ApplicationController
  include BasicApi

  respond_to :json
  
  before_filter :set_format 

  rescue_from Exception do |exception| internal_server_error(exception) end
  rescue_from ActionController::UnknownAction, :with => :unknown_action
  rescue_from ActionController::RoutingError, :with => :route_not_found
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from Api::BasicApi::NotLogedIn, with: :not_loged_in
  rescue_from Api::BasicApi::NoParameter, with: :no_parameter_found

end