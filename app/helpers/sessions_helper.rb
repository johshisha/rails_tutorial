module SessionsHelper
  #log in with user information
  def log_in(user)
    session[:user_id] = user.id
  end

  #if user logged in, return logged in user 
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  #return logged in(true) or not logged in(false)
  def logged_in?
    !current_user.nil?
  end


  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

end
