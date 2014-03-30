class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :miniprofiler


  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  def check_admin!
    authorize! :admin, current_user, :message => 'Not authorized as an administrator.'
  end

  private

  def roomtemp_suppress_messages?
    suppress = params.permit('roomtemp_suppress_messages')['roomtemp_suppress_messages']
    '1' == suppress.to_s
  end

  def miniprofiler
    if defined? Rack::MiniProfiler
      Rack::MiniProfiler.authorize_request # if user.admin?
    end
  end
end
