module SessionsHelper
  #log in with user information
  def log_in(user)
    session[:user_id] = user.id
  end

  #remember user session
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  #if user logged in, return logged in user 
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: session[:user_id])
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  
  # check correct user
  def current_user?(user)
    user == current_user
  end

  #return logged in(true) or not logged in(false)
  def logged_in?
    !current_user.nil?
  end
  
  #discard permanent session
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
  
  # redirect to remembered url
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default) # method終了までリダイレクト処理は行われない
    session.delete(:forwarding_url)
  end
  
  # remember url of before accessing
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
