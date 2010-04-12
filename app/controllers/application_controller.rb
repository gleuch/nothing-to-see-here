class NotAllowed < StandardError; end
class NotFound < StandardError; end
class MaxQuota < StandardError; end


class ApplicationController < ActionController::Base
  include AuthenticatedSystem

  helper :all
  protect_from_forgery

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

  before_filter   :app_setup


protected

  def app_setup
    User.current_user = current_user if logged_in?
  end


  def prod?; ENV['RAILS_ENV'] == 'production'; end
  def dev?; ENV['RAILS_ENV'] == 'development'; end
  helper_method :dev?, :prod?

  def role?(role); current_user && current_user.has_role?(role); end
  def badge?(badge); current_user && current_user.has_badge?(badge); end
  helper_method :role?, :badge?


  def pluralize(num, singular, plural=nil); "#{num} #{num == 1 ? singular : (!plural.blank? ? plural : singular.pluralize)}"; end
  helper_method :pluralize


  def pagination_setup(per_page=20)
    @page = params[:page].to_i rescue 1
    @page = 1 if @page < 1

    @per_page = per_page
  end


  def section_path(object)
    if object.class == Project
      link = portfolio_client_project_path(object.client.portfolio.slug, object.client.slug, object)
    elsif object.class == Client
      link = portfolio_client_path(object.portfolio.slug, object.slug)
    elsif object.class == Portfolio
      link = portfolio_path(object.slug)
    end
    link || nil
  end
  helper_method :section_path


  def timesheet_time_float(time)
    # Allow conversion of time (as ##:##) to float
    if time =~ /^\d+\:\d+$/ || time =~ /^\:\d+$/ || time =~ /^\d+\:$/
      hours = (time.match(/^(\d+)/)[1]).to_i rescue 0
      hours ||= 0
      mins = (time.match(/(\d+)$/)[1]).to_i rescue 0
      mins ||= 0
      float = (hours + (mins/60.to_f)).to_f
    # time is float
    elsif time =~ /^\d+$/ || time =~ /^\d+\.\d+$/ || time =~ /^\.\d+$/ || time =~ /^\d+\.$/
      float = time.to_f
    end
    return float || nil # return nil if not given proper formatting
  end

  def timesheet_time_format(time, *opts)
    options, str = {:fancy => false}.merge(opts.extract_options!), []

    time = 0 if time.blank? || time =~ /[A-Z]/i

    if options[:fancy]
      minutes = (time*60) % 60
      hours = (time*60-minutes)/60.to_f
      if hours > 24
        hours = (hours % 24)
        days = ((time*60-minutes)/60.to_f - hours) / 24.to_f
        str << pluralize(days.to_i, 'day')
      end
      
      str << pluralize(hours.to_i, 'hour') unless hours == 0
      str << pluralize(minutes.to_i, 'minute')
      str = str.join(', ')
    else
      str = "#{sprintf '%0.02f', time} hours"
    end

    return str
  end
  helper_method :timesheet_time_format

  def remember_redirect
    session[:return_to] = params[:redirect] unless params[:redirect].blank?
    session[:return_to] ||= request.env['HTTP_REFERER'] if !request.env['HTTP_REFERER'].blank? && request.env['HTTP_REFERER'] != request.path
  end

end
