class Api::V1::UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:signin, :logged_in,:create]
  def logged_in
    if current_user
    	render json: current_user
    else
      render json: {message:"No User Logged in"}, status: :ok
    end
  end
  def signin
    #This method will handle the sign in of a user through an ajax request.
  	#The user from the frontend will enter his/her credentials in the modal. The Ember app will then make an ajax request to our rails app
  	#with the data entered by the user. Then we will authenticate the user through devise and set the current_user.
  	# If successfully authenticated we will respond with the user_id to the frontend otherwise we will respond with errors
  	# encountered.
		sign_out(current_user) if current_user
    user = User.find_by_email(params[:user][:email].downcase())
		if user.nil?
      render json: {message: 'username or prassword incorrect' }
		else
			if user.valid_password?(params[:user][:password])      #Check the password validtity
			  sign_in(:user, user)                                #Sign in the user
				if current_user
          render json: {message: "sign_in success"}
				end
			else
				render json: {message: "username or prassword incorrect"}
			end
		end
  end
  def create
    user = User.new(user_params)
    if user.save
      render :json => user
    else
      render json: user, status: 422 , serializer: ActiveModel::Serializer::ErrorSerializer
    end
  end
  def user_params
   ActiveModelSerializers::Deserialization.jsonapi_parse(params,  only: [:email,'password', "password-confirmation"])
  end
end
