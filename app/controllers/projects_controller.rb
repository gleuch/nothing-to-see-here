class ProjectsController < ApplicationController

  before_filter :login_required
  before_filter :get_portfolio
  before_filter :get_client
  before_filter :check_user_permissions, :only => [:new, :create, :edit, :update, :destroy]
  before_filter :check_account_limits, :only => [:new, :create]

  def index
    @projects = @client.projects rescue nil
    
    # Skip this page if user is only part of one portfolio.
    redirect_to( portfolio_client_project_path(@portfolio.slug, @client.slug, @project.first) ) and return unless @projects.blank? || @projects.count != 1
  end

  def show
    @project = @client.projects.find_by_url_slug(params[:id]) rescue nil
    @project ||= @client.projects.find(params[:id]) rescue nil

    unless @project.blank?
      @notifications = @project.notifications.paginate(:per_page => @per_page, :page => @page)
    end
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new( params[:project].merge({ :portfolio_id => @portfolio.id, :client_id => @client.id }) )
    if @project.save
      @project.add_user(current_user)

      flash[:notice] = "Your project was successfully created."
      redirect_to portfolio_client_project_path(@portfolio.slug, @client.slug, @project)
    else
      flash[:error] = "There was an error when saving this project."
      render :action => 'new'
    end
  end


protected

  def get_portfolio
    @portfolio = current_user.portfolios.find_by_url_slug(params[:portfolio_id]) rescue nil
    @portfolio ||= current_user.portfolios.find(params[:portfolio_id]) rescue nil
    raise NotFound, "The portfolio requested was not found" if @portfolio.blank?
  end

  def get_client
    @client = @portfolio.clients.find_by_url_slug(params[:client_id]) rescue nil
    @client ||= @portfolio.clients.find(params[:client_id]) rescue nil
    raise NotFound, "The client requested was not found." if @client.blank? && !(%w{index show}.include?(action_name))
  end

  def check_user_permissions
    raise NotAllowed, "You do not have permission to make this request." if current_user.owner?(@portfolio)
  end

  def check_account_limits
    max_projects = @client.option_projects_count
    if @client.projects.count >= max_projects
      raise MaxQuota, "You have reached the maximum number of #{pluralize max_projects, 'project'} you can create for this client."
    end
  end

end
