module Authenticatable
  extend ActiveSupport::Concern
  include JWTWrapper

  included do
    before_action :authenticate_user!
  end

  private

  def authenticate_user!
    token = extract_token_from_header
    return render_unauthorized unless token

    decoded_token = JWTWrapper.decode(token)
    return render_unauthorized unless decoded_token

    @current_user = User.find(decoded_token['user_id'])
    return render_unauthorized unless @current_user
  rescue ActiveRecord::RecordNotFound
    render_unauthorized
  end

  def current_user
    @current_user
  end

  def extract_token_from_header
    auth_header = request.headers['Authorization']
    return nil unless auth_header&.start_with?('Bearer ')
    
    auth_header.split(' ').last
  end

  def render_unauthorized
    render json: { 
      error: 'Unauthorized', 
      message: 'Invalid or missing authentication token' 
    }, status: :unauthorized
  end
end
