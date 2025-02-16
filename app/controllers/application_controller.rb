class ApplicationController < ActionController::API
  # before_action :authorize_request

  def authorize_request
    header = request.headers['Authorization']
    
    if header.nil?
      return render json: { error: 'Token is missing' }, status: :unauthorized
    end

    token = header.split(' ').last
    decoded = JsonWebToken.decode(token)

    if decoded.nil?
      return render json: { error: 'Invalid token' }, status: :unauthorized
    end

    @current_user = User.find_by(id: decoded[:user_id])

    return render json: { error: 'User not found' }, status: :unauthorized unless @current_user
  rescue JWT::DecodeError
    render json: { error: 'Invalid token' }, status: :unauthorized
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User not found' }, status: :unauthorized
  end
end
