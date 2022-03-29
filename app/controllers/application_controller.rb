class ApplicationController < ActionController::API
  include ActionController::Serialization

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActionController::ParameterMissing, with: :bad_request
 
  private
 
  def current_user
	  @current_user ||= User.find(1)
	end	

 def record_not_found(exeption)
    render json: {error: exeption.message}, status: 404
  end

  def bad_request(exeption)
    render json: {error: exeption.message}, status: 400
  end

  def unprocessable_entity(message)
    render json: {error: message}, status: 422
  end
end
