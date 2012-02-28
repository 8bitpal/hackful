class Api::V1::UsersController < Api::ApplicationController
  before_filter :check_login, only: [:update, :notifications]

  # GET /api/v1/user/:id
  def show
    user = User.find(params[:id])
    raise ActiveRecord::RecordNotFound if user.nil?
    
    user_json = {:name => user.name, :id => user.id}
    # TODO: Email address only for registred users and loged in ?
    user_json[:email] = user.email if user_signed_in?
    
    render :json => user_json
  end
  
  # PUT /api/v1/user
  def update
    raise Api::BasicApi::NoParameter if params["user"].blank?
    
    #return render :json => params
    #return render :json => {:id => current_user.id, :signed_in => user_signed_in?}

    user = User.find(current_user.id)
    if user.update_attributes(params[:user])
      render :json => success_message("Successfully updated user")
    else
      errors = {:errors => user.errors}
      render :json => failure_message("Couldn't update user", errors), 
        :status => 422
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
      render :json => success_message("Sign up was successful", user_json), 
        :status => 201
    else
      errors = {:errors => user.errors}
      render :json => failure_message("Couldn't sign up user", errors),
        :status => 422
    end
  end

  # GET /api/v1/user/notifications
  def notifications
    notifications = User.notifications(current_user)
    notifiocations_json = notifications.to_json
    
    notifications[:new_notifications].update_all(:unread => false)

    render :json => notifiocations_json
  end

end
