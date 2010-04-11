class ClientsController < ApplicationController

  before_filter :login_required
  before_filter :get_portfolio
  before_filter :check_user_permissions, :only => [:new, :create, :edit, :update, :destroy]
  before_filter :check_account_limits, :only => [:new, :create]

  def index
    @clients = @portfolio.clients rescue nil
    
    # Skip this page if user is only part of one portfolio.
    redirect_to( portfolio_client_path(@portfolio.slug, @clients.first.slug) ) and return if @clients.length == 1
  end

  def show
    @client = @portfolio.clients.find_by_url_slug(params[:id]) rescue nil
    @client ||= @portfolio.clients.find(params[:id]) rescue nil
  end

  def new
    @client = Client.new
  end

  def create
    @client = Client.new( params[:client].merge({ :portfolio_id => @portfolio.id }) )
    if @client.save
      @client.users << current_user

      flash[:notice] = "Your client was successfully created."
      redirect_to portfolio_client_path(@portfolio.slug, @client.slug)
    else
      flash[:error] = "There was an error when saving this client."
      render :action => 'new'
    end
  end


protected

  def get_portfolio
    @portfolio = current_user.portfolios.find_by_url_slug(params[:portfolio_id]) rescue nil
    @portfolio ||= current_user.portfolios.find(params[:portfolio_id]) rescue nil
    raise NotFound, "The portfolio requested was not found" if @portfolio.blank?
  end

  def check_user_permissions
    raise NotAllowed, "You do not have permission to make this request." if current_user.owned_account.blank?
  end

  def check_account_limits
    max_clients = @portfolio.option_clients_count
    if @portfolio.clients.count >= max_clients
      raise MaxQuota, "You have reached the maximum number of #{pluralize max_clients, 'client'} you can create for this portfolio."
    end
  end

end
