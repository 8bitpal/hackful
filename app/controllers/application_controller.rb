class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :meta_defaults

  def meta_defaults
	@title = ""
    @meta_keywords = "Europe, Startups, Entrepreneurs"
    @meta_description = "Hackful Europe is a place for European entrepreneurs to share demos, stories or ask questions."
  end

  def after_sign_out_path_for(resource) 
    super
  end

  def after_sign_in_path_for(resource) 
    super
  end

  def page_number(page = nil)
    page.nil? ? page = 1 : page = page.to_i
    return page
  end
end
