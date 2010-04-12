class TimesheetsController < ApplicationController

  before_filter :login_required
  before_filter :get_portfolio
  before_filter :get_client
  before_filter :get_project
  before_filter :get_timesheet, :only => [:show, :edit, :update, :destroy]
  before_filter :initalize_new_timesheet, :only => [:index, :new]
  before_filter :remember_redirect, :only => [:create, :update] # Remember where to redirect!

  def index
    order, conditions = 'created_at DESC', []

    @object = @project
    @object ||= @client
    @object ||= @portfolio
    @object ||= current_user

    # Filter by single user
    conditions << "user_id=#{params[:user_id]}" unless @object.class == User || params[:user_id].blank?

    # Date range
    conditions << "worked_at >= #{params[:date_start]}" unless params[:date_start].blank?
    conditions << "worked_at <= #{params[:date_end]}" unless params[:date_end].blank?

    @timesheets = @object.timesheets.all(:order => order, :conditions => conditions.join(' AND '))
    @timesheets_total_time = @object.timesheets.first(:select => 'SUM(time_spent) as time_spent', :conditions => conditions.join(' AND ')).time_spent rescue 0.to_f
  end

  def show
  end

  def new
  end

  def create
    params[:timesheet][:time_spent] = timesheet_time_float(params[:timesheet][:time_spent])

    @timesheet = Timesheet.new( params[:timesheet].merge({ :portfolio => @portfolio, :client => @client, :project => @project, :user => current_user }) )
    if @timesheet.save
      flash[:notice] = "Your timesheet was successfully created."
      redirect_back_or_default(section_path(@project || @client || @portfolio)) and return
    else
      flash[:error] = "There was an error when saving this timesheet."
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    if @timesheet.save
      flash[:notice] = "Your timesheet was successfully created."
      redirect_back_or_default(section_path(@project || @client || @portfolio)) and return
    else
      flash[:error] = "There was an error when saving this timesheet."
      render :action => 'new'
    end
  end


protected

  def get_portfolio
    @portfolio = current_user.portfolios.find_by_url_slug(params[:portfolio_id]) rescue nil
    @portfolio ||= current_user.portfolios.find(params[:portfolio_id]) rescue nil
    @portfolio ||= current_user.portfolio.first if current_user.portfolios.count == 1 # If only one, let us be smart about this...
    raise NotFound, "The portfolio requested was not found." if @portfolio.blank? && !(%w{index show}.include?(action_name))
  end

  def get_client
    @client = @portfolio.clients.find_by_url_slug(params[:client_id]) rescue nil
    @client ||= @portfolio.clients.find(params[:client_id]) rescue nil
    # @client ||= @portfolio.clients.first if @portfolio.clients.count == 1 # If only one, let us be smart about this...
    raise NotFound, "The client requested was not found." if @client.blank? && !(%w{index show}.include?(action_name))
  end

  def get_project
    @project = @client.projects.find(params[:project_id]) rescue nil
    # @project = @client.projects.first if @client.projects.count == 1 # If only one, let us be smart about this...
  end

  def initalize_new_timesheet
    @timesheet = Timesheet.new
    @timesheet.worked_at = Time.now.to_s(:db).gsub(/([0-9\-]+)(.*)/, '\1')
  end

end
