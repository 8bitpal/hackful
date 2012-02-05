class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :meta_defaults

  def meta_defaults
		@title = ""
    @meta_keywords = "Europe, Startups, Entrepreneurs"
    @meta_description = "Hackful Europe is a place for European entrepreneurs to share demos, stories or ask questions."
  end
end
