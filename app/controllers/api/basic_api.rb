require 'action_controller'
module Api::BasicApi
  class NotLogedIn < StandardError; end
  class NoParameter < StandardError; end

  def not_found
    head :not_found
  end

  def internal_server_error(exception = nil)
    if Rails.env.production? then
      head 500
    else
      error = { 
       :error => "internal server error", 
       :exception => exception.message, 
       :stacktrace => exception.backtrace 
      }
      render :json => error, :status => 500
    end
  end

  def no_parameter_found
    render :json => failure_message("Missing parameters"), :status => 422
  end

  def not_loged_in
    render :json => failure_message("Please login"), :status => 401
  end

  def success_message(message, info = nil)
    json = {:success => true, :message => message}
    json.merge! info unless info.nil?  
    return json
  end

  def failure_message(message, errors = nil)
    json = {:success => false, :message => message}
    json.merge! errors unless errors.nil?  
    return json
  end

  def check_login
    raise NotLogedIn unless user_signed_in?
  end

  private
  def set_format
    request.format = 'json'
  end
end