class Api::ApplicationController < ApplicationController
  include BasicApi

  respond_to :json

  before_filter :set_format 

  rescue_from Exception, with: :internal_server_error
  rescue_from ActionController::UnknownAction, :with => :unknown_action
  rescue_from ActionController::RoutingError, :with => :route_not_found
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  
  # # FIXME: Should be removed in production
  rescue_from Exception do |exception|
    error = { :error      => "internal server error", 
              :exception  => exception.message, 
              :stacktrace => exception.backtrace }
    render :json => error, :status => 500
  end
end