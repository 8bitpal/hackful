require 'action_controller'
module Api::BasicApi
  def parse_body_json
    begin
      # TODO: change name cause it is to confussing
      @params = JSON.parse(request.body.read)
    rescue JSON::ParserError => e
      head :bad_request
    end
  end

  def not_found
    head :not_found
  end

  def internal_server_error
    head 500
    #error = { 
    #  :error => "internal server error", 
    #  :exception => exception.message, 
    #  :stacktrace => exception.backtrace 
    #}
    #render :json => error, :status => 500
  end

  def no_parameter_found
    respond_with failure_message("Missing parameters"), :status => 422
  end

  def not_loged_in
    respond_with failure_message("Please login"), :status => 401
  end

  def success_message(message, info = nil)
    json = {:success => true, :message => message}
    json.merge! info unless info.nil?  
    return json
  end

  def failure_message(message)
    return {:success => false, :message => message}
  end

  private
  def set_format
    request.format = 'json'
  end
end