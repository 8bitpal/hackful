class Api::V1::UsersController < Api::ApplicationController
  prepend_before_filter :require_no_authentication, :only => [:signup]

  # GET /api/v1/users/:name(/:page)
  def show
    #page = page(params[:page])
    user = User.find_by_name(params[:name])
    raise ActiveRecord::RecordNotFound if user.nil?

    # TODO: find_all_posts
    posts = Post.find_ordered(user.id, page)
  	
    # user_json = {:name => user.name, :posts => posts, :page => page}
    user_json = {:name => user.name, :id => user.id}
    # TODO: Email address only for registred users and loged in ?
    user_json[:email] = user.email if user_signed_in?
    
    render :json => user_json
  end
  
  # PUT /api/v1/users/:name
  def update
    puts @params
    raise "NotLogedIn"  unless user_signed_in?
    raise "NoParameter" if @params["user"].blank?
      
    user = User.find(current_user.id)
    if user.update_attributes(params[:user])
      puts success_message("Successfully updated user")
      render :json => success_message("Successfully updated user")
    else
      puts failure_message("Couldn't update user")
      render :json => failure_message("Couldn't update user"), :status => 422
    end
  end
  
  # POST /api/v1/signup
  def signup
    user = User.new(params[:user])
    user.reset_authentication_token!
    if user.save
      user_json = {:user => {
        :name => user.name, 
        :email => user.email, 
        :auth_token => user.authentication_token
      }}
      respond_with success_message("Sign up was successful", user_json), 
        :status => 201
    else
      warden.custom_failure!
      errors = {:errors => user.errors}
      respond_with failure_message("Couldn't sign up user"), :status => 422
    end
  end

end
