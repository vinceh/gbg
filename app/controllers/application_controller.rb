class ApplicationController < ActionController::Base
  protect_from_forgery

  def adminsession
    if !session[:admin]
      redirect_to :controller => :home
    end
  end
end
