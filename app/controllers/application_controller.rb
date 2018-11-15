class ApplicationController < ActionController::Base
  helper_method :current_user

  def current_user
    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  def require_login
    unless logged_in?
      redirect_to new_session_url
    end
  end

  def logged_in?
    !!current_user
  end

  def login!(user)
    session[:session_token] = user.reset_session_token!
  end

  def logout!
    session[:session_token] = nil
    if logged_in?
      current_user.reset_session_token!
      @current_user = nil
    end
  end

end
